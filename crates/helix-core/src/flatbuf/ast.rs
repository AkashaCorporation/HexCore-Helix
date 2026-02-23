//! Serialização FlatBuffer de AST (Abstract Syntax Tree).
//!
//! Usa a API do FlatBufferBuilder para construir buffers compatíveis
//! com o schema `ast.fbs`.

use flatbuffers::FlatBufferBuilder;

/// Resultado da deserialização de um AST
#[derive(Debug, Clone, PartialEq)]
pub struct AstData {
    pub module_name: String,
    pub functions: Vec<AstFunctionData>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct AstFunctionData {
    pub name: String,
    pub address: u64,
    pub source: String,
    pub param_count: u32,
    pub local_count: u32,
    pub stmt_count: u32,
}

/// Serializa dados de AST em FlatBuffer.
pub fn serialize_ast(data: &AstData) -> Result<Vec<u8>, String> {
    if data.functions.is_empty() {
        return Err("AST vazio: nenhuma função para serializar".into());
    }

    let mut builder = FlatBufferBuilder::with_capacity(2048);

    // Construir funções
    let mut func_offsets = Vec::with_capacity(data.functions.len());
    for func in &data.functions {
        let name_offset = builder.create_string(&func.name);
        let source_offset = builder.create_string(&func.source);

        // DecompiledFunction table:
        // field 0 (vt 4): name
        // field 1 (vt 6): address (u64)
        // field 2 (vt 8): source (pseudo-C)
        // field 3 (vt 10): param_count
        // field 4 (vt 12): local_count
        // field 5 (vt 14): stmt_count
        let start = builder.start_table();
        builder.push_slot_always(4, name_offset);
        builder.push_slot_always::<u64>(6, func.address);
        builder.push_slot_always(8, source_offset);
        builder.push_slot::<u32>(10, func.param_count, 0);
        builder.push_slot::<u32>(12, func.local_count, 0);
        builder.push_slot::<u32>(14, func.stmt_count, 0);
        let func_end = builder.end_table(start);
        func_offsets.push(func_end);
    }

    let funcs_vec = builder.create_vector(&func_offsets);

    // AstModule
    let module_name_offset = builder.create_string(&data.module_name);
    let start = builder.start_table();
    builder.push_slot_always(4, module_name_offset);
    builder.push_slot_always(6, funcs_vec);
    let module_end = builder.end_table(start);

    builder.finish(module_end, Some(super::AST_FILE_IDENTIFIER));

    Ok(builder.finished_data().to_vec())
}

/// Deserializa um buffer FlatBuffer de AST.
pub fn deserialize_ast(buf: &[u8]) -> Result<AstData, String> {
    if buf.len() < 8 {
        return Err("Buffer AST muito pequeno".into());
    }

    let ident = &buf[4..8];
    if ident != super::AST_FILE_IDENTIFIER.as_bytes() {
        return Err(format!(
            "File identifier inválido: esperado '{}', encontrado '{}'",
            super::AST_FILE_IDENTIFIER,
            String::from_utf8_lossy(ident)
        ));
    }

    let root_pos = read_u32(buf, 0) as usize;
    let module_name = read_fb_string(buf, root_pos, 4).unwrap_or_default();

    let func_positions = read_fb_vector_tables(buf, root_pos, 6);
    let mut functions = Vec::with_capacity(func_positions.len());

    for &fpos in &func_positions {
        let name = read_fb_string(buf, fpos, 4).unwrap_or_default();
        let address = read_fb_u64(buf, fpos, 6);
        let source = read_fb_string(buf, fpos, 8).unwrap_or_default();
        let param_count = read_fb_u32(buf, fpos, 10);
        let local_count = read_fb_u32(buf, fpos, 12);
        let stmt_count = read_fb_u32(buf, fpos, 14);

        functions.push(AstFunctionData {
            name,
            address,
            source,
            param_count,
            local_count,
            stmt_count,
        });
    }

    Ok(AstData {
        module_name,
        functions,
    })
}

// ── Helpers de leitura (mesma lógica do cfg.rs) ──────────────────────

fn read_u32(buf: &[u8], pos: usize) -> u32 {
    if pos + 4 > buf.len() { return 0; }
    u32::from_le_bytes([buf[pos], buf[pos+1], buf[pos+2], buf[pos+3]])
}

fn read_u16(buf: &[u8], pos: usize) -> u16 {
    if pos + 2 > buf.len() { return 0; }
    u16::from_le_bytes([buf[pos], buf[pos+1]])
}

fn read_u64(buf: &[u8], pos: usize) -> u64 {
    if pos + 8 > buf.len() { return 0; }
    u64::from_le_bytes([
        buf[pos], buf[pos+1], buf[pos+2], buf[pos+3],
        buf[pos+4], buf[pos+5], buf[pos+6], buf[pos+7],
    ])
}

fn read_fb_string(buf: &[u8], table_pos: usize, field_offset: u16) -> Option<String> {
    let vtable_offset = read_u32(buf, table_pos) as i32;
    let vtable_pos = (table_pos as i32 - vtable_offset) as usize;
    if vtable_pos + 4 > buf.len() { return None; }

    let vtable_size = read_u16(buf, vtable_pos) as usize;
    let field_idx = field_offset as usize;
    if field_idx + 2 > vtable_size { return None; }

    let field_rel = read_u16(buf, vtable_pos + field_idx) as usize;
    if field_rel == 0 { return None; }

    let string_offset_pos = table_pos + field_rel;
    let string_rel = read_u32(buf, string_offset_pos) as usize;
    let string_pos = string_offset_pos + string_rel;

    let str_len = read_u32(buf, string_pos) as usize;
    let str_start = string_pos + 4;
    if str_start + str_len > buf.len() { return None; }

    String::from_utf8(buf[str_start..str_start + str_len].to_vec()).ok()
}

fn read_fb_u64(buf: &[u8], table_pos: usize, field_offset: u16) -> u64 {
    let vtable_offset = read_u32(buf, table_pos) as i32;
    let vtable_pos = (table_pos as i32 - vtable_offset) as usize;
    if vtable_pos + 4 > buf.len() { return 0; }

    let vtable_size = read_u16(buf, vtable_pos) as usize;
    let field_idx = field_offset as usize;
    if field_idx + 2 > vtable_size { return 0; }

    let field_rel = read_u16(buf, vtable_pos + field_idx) as usize;
    if field_rel == 0 { return 0; }

    read_u64(buf, table_pos + field_rel)
}

fn read_fb_u32(buf: &[u8], table_pos: usize, field_offset: u16) -> u32 {
    let vtable_offset = read_u32(buf, table_pos) as i32;
    let vtable_pos = (table_pos as i32 - vtable_offset) as usize;
    if vtable_pos + 4 > buf.len() { return 0; }

    let vtable_size = read_u16(buf, vtable_pos) as usize;
    let field_idx = field_offset as usize;
    if field_idx + 2 > vtable_size { return 0; }

    let field_rel = read_u16(buf, vtable_pos + field_idx) as usize;
    if field_rel == 0 { return 0; }

    read_u32(buf, table_pos + field_rel)
}

fn read_fb_vector_tables(buf: &[u8], table_pos: usize, field_offset: u16) -> Vec<usize> {
    let vtable_offset = read_u32(buf, table_pos) as i32;
    let vtable_pos = (table_pos as i32 - vtable_offset) as usize;
    if vtable_pos + 4 > buf.len() { return Vec::new(); }

    let vtable_size = read_u16(buf, vtable_pos) as usize;
    let field_idx = field_offset as usize;
    if field_idx + 2 > vtable_size { return Vec::new(); }

    let field_rel = read_u16(buf, vtable_pos + field_idx) as usize;
    if field_rel == 0 { return Vec::new(); }

    let vec_offset_pos = table_pos + field_rel;
    let vec_rel = read_u32(buf, vec_offset_pos) as usize;
    let vec_pos = vec_offset_pos + vec_rel;

    let count = read_u32(buf, vec_pos) as usize;
    let mut positions = Vec::with_capacity(count);

    for i in 0..count {
        let elem_offset_pos = vec_pos + 4 + i * 4;
        let elem_rel = read_u32(buf, elem_offset_pos) as usize;
        positions.push(elem_offset_pos + elem_rel);
    }

    positions
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ast_roundtrip() {
        let data = AstData {
            module_name: "wwz_module".into(),
            functions: vec![
                AstFunctionData {
                    name: "sub_140000000".into(),
                    address: 0x140000000,
                    source: "int64_t sub_140000000(void) {\n    rax = rbx + 1;\n}".into(),
                    param_count: 0,
                    local_count: 2,
                    stmt_count: 1,
                },
            ],
        };

        let buf = serialize_ast(&data).expect("serialize falhou");
        assert_eq!(&buf[4..8], b"HAST");

        let decoded = deserialize_ast(&buf).expect("deserialize falhou");
        assert_eq!(decoded.module_name, data.module_name);
        assert_eq!(decoded.functions.len(), 1);
        assert_eq!(decoded.functions[0].name, "sub_140000000");
        assert_eq!(decoded.functions[0].address, 0x140000000);
        assert!(decoded.functions[0].source.contains("rax = rbx + 1"));
        assert_eq!(decoded.functions[0].local_count, 2);
        assert_eq!(decoded.functions[0].stmt_count, 1);
    }

    #[test]
    fn ast_empty_returns_error() {
        let data = AstData {
            module_name: "empty".into(),
            functions: vec![],
        };
        assert!(serialize_ast(&data).is_err());
    }

    #[test]
    fn ast_invalid_buffer() {
        assert!(deserialize_ast(&[0, 0]).is_err());
    }
}
