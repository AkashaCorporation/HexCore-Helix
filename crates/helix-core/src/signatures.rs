//! Lightweight signature database for resolving call targets into known symbols.
//!
//! The database supports loading user-provided mappings from CSV files:
//! - `signatures/windows_crt_win32.csv`
//! - `signatures/signatures.csv`
//! - `signatures.csv`
//!
//! CSV format:
//! `0x140123456,CreateFileW,BOOL`
//! `0x140123500,memcpy,void*`

use std::collections::HashMap;
use std::path::Path;
use std::sync::OnceLock;

/// Resolved function signature metadata.
#[derive(Debug, Clone)]
pub struct Signature {
    pub name: String,
    pub return_type: String,
}

/// Address-based signature database.
#[derive(Debug, Clone, Default)]
pub struct SignatureDb {
    by_address: HashMap<u64, Signature>,
}

impl SignatureDb {
    /// Create an empty signature database.
    pub fn new() -> Self {
        Self::default()
    }

    /// Add or replace a signature mapping.
    pub fn insert(
        &mut self,
        address: u64,
        name: impl Into<String>,
        return_type: impl Into<String>,
    ) {
        self.by_address.insert(
            address,
            Signature {
                name: name.into(),
                return_type: return_type.into(),
            },
        );
    }

    /// Look up a signature by absolute target address.
    pub fn lookup(&self, address: u64) -> Option<&Signature> {
        self.by_address.get(&address)
    }

    /// Load known signatures from conventional CSV locations.
    pub fn load_default() -> Self {
        let mut db = Self::new();

        // Preferred: split files by domain.
        db.load_csv_if_exists(Path::new("signatures/windows_crt_win32.csv"));
        db.load_csv_if_exists(Path::new("signatures/signatures.csv"));
        // Backward-compatible single-file layout.
        db.load_csv_if_exists(Path::new("signatures.csv"));

        db
    }

    fn load_csv_if_exists(&mut self, path: &Path) {
        let Ok(contents) = std::fs::read_to_string(path) else {
            return;
        };
        self.load_csv(&contents);
    }

    fn load_csv(&mut self, contents: &str) {
        for raw_line in contents.lines() {
            let line = raw_line.trim();
            if line.is_empty() || line.starts_with('#') {
                continue;
            }

            let fields: Vec<&str> = line.split(',').map(|p| p.trim()).collect();
            if fields.len() < 2 {
                continue;
            }

            let Some(address) = parse_address(fields[0]) else {
                continue;
            };

            let name = fields[1];
            if name.is_empty() {
                continue;
            }

            let return_type = fields.get(2).copied().unwrap_or("void*");
            self.insert(address, name, return_type);
        }
    }
}

fn parse_address(s: &str) -> Option<u64> {
    let s = s.trim();
    if let Some(hex) = s.strip_prefix("0x").or_else(|| s.strip_prefix("0X")) {
        return u64::from_str_radix(hex, 16).ok();
    }
    if let Ok(decimal) = s.parse::<u64>() {
        return Some(decimal);
    }
    if s.chars().all(|c| c.is_ascii_hexdigit()) {
        // Accept plain hex values commonly exported by tooling.
        return u64::from_str_radix(s, 16).ok();
    }
    None
}

/// Process-wide lazily loaded signature database.
pub fn default_signature_db() -> &'static SignatureDb {
    static DB: OnceLock<SignatureDb> = OnceLock::new();
    DB.get_or_init(SignatureDb::load_default)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_csv_rows() {
        let mut db = SignatureDb::new();
        db.load_csv(
            r#"
                # addr,name,ret
                0x140001000,CreateFileW,HANDLE
                0x140001010,CloseHandle,BOOL
                0x140001020,memcpy,void*
            "#,
        );

        assert_eq!(
            db.lookup(0x140001000).map(|s| s.name.as_str()),
            Some("CreateFileW")
        );
        assert_eq!(
            db.lookup(0x140001010).map(|s| s.return_type.as_str()),
            Some("BOOL")
        );
        assert_eq!(
            db.lookup(0x140001020).map(|s| s.name.as_str()),
            Some("memcpy")
        );
    }
}
