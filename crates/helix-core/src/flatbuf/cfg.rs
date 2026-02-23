//! Serialização FlatBuffer de CFG (Control Flow Graph).
//!
//! Usa a API do FlatBufferBuilder para construir buffers compatíveis
//! com o schema `cfg.fbs`. Sem código gerado por `flatc`, usamos
//! a API de baixo nível do builder.

use flatbuffers::FlatBufferBuilder;

/// Resultado da deserialização de um CFG
#[derive(Debug, Clone, PartialEq)]
pub struct CfgData {
    pub module_name: String,
    pub functions: Vec<CfgFunctionData>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct CfgFunctionData {
    pub name: String,
    pub entry_address: u64,
    pub instruction_count: u32,
    pub block_count: u32,
}

// Vtable field IDs (slot indices para push_slot)
// CfgFunction: name=4, entry=6, arch=8, blocks=10, instruction_count=12
// CfgModule: name=4, functions=6

/// Serializa dados de CFG em FlatBuffer.
pub fn serialize_cfg(data: &CfgData) -> Result<Vec<u8>, String> {
    if data.functions.is_empty() {
        return Err("CFG vazio: nenhuma função para serializar".into());
    }

    let mut builder = FlatBufferBuilder::with_capacity(1024);

    // Construir funções (ordem reversa para FlatBuffer)
    let mut func_offsets = Vec::with_capacity(data.functions.len());
    for func in &data.functions {
        let name_offset = builder.create_string(&func.name);

        let start = builder.start_table();
        builder.push_slot_always(4, name_offset);
        builder.push_slot_always::<u64>(6, func.entry_address);
        builder.push_slot::<u32>(12, func.instruction_count, 0);
        let func_end = builder.end_table(start);
        func_offsets.push(func_end);
    }

    // Criar vetor de offsets de funções
    let funcs_vec = builder.create_vector(&func_offsets);

    // CfgModule
    let module_name_offset = builder.create_string(&data.module_name);
    let start = builder.start_table();
    builder.push_slot_always(4, module_name_offset);
    builder.push_slot_always(6, funcs_vec);
    let module_end = builder.end_table(start);

    builder.finish(module_end, Some(super::CFG_FILE_IDENTIFIER));

    Ok(builder.finished_data().to_vec())
}

/// Deserializa um buffer FlatBuffer de CFG.
///
/// Usa leitura manual do formato binário FlatBuffer.
pub fn deserialize_cfg(buf: &[u8]) -> Result<CfgData, String> {
    if buf.len() < 8 {
        return Err("Buffer CFG muito pequeno".into());
    }

    // Verificar file identifier
    let ident = &buf[4..8];
    if ident != super::CFG_FILE_IDENTIFIER.as_bytes() {
        return Err(format!(
            "File identifier inválido: esperado '{}', encontrado '{}'",
            super::CFG_FILE_IDENTIFIER,
            String::from_utf8_lossy(ident)
        ));
    }

    // Ler root table offset
    let root_offset = read_u32(buf, 0) as usize;
    let root_pos = root_offset;

    // Ler vtable
    let (module_name, functions) = read_cfg_module(buf, root_pos)?;

    Ok(CfgData {
        module_name,
        functions,
    })
}

/// Lê o nome da primeira função de um CFG FlatBuffer sem deserialização completa.
pub fn read_cfg_function_name(buf: &[u8]) -> Result<Option<String>, String> {
    if buf.len() < 8 {
        return Ok(None);
    }

    let data = deserialize_cfg(buf)?;
    Ok(data.functions.first().map(|f| f.name.clone()))
}

// ── Helpers de leitura manual do formato FlatBuffer ──────────────────

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

/// Lê uma string FlatBuffer (offset indireto → length-prefixed UTF-8)
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

/// Lê um campo u64 de uma table FlatBuffer
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

/// Lê um campo u32 de uma table FlatBuffer
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

/// Lê um vetor de tables FlatBuffer
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

fn read_cfg_module(buf: &[u8], root_pos: usize) -> Result<(String, Vec<CfgFunctionData>), String> {
    let module_name = read_fb_string(buf, root_pos, 4).unwrap_or_default();

    let func_positions = read_fb_vector_tables(buf, root_pos, 6);
    let mut functions = Vec::with_capacity(func_positions.len());

    for &fpos in &func_positions {
        let name = read_fb_string(buf, fpos, 4).unwrap_or_default();
        let entry_address = read_fb_u64(buf, fpos, 6);
        let instruction_count = read_fb_u32(buf, fpos, 12);

        functions.push(CfgFunctionData {
            name,
            entry_address,
            instruction_count,
            block_count: 0,
        });
    }

    Ok((module_name, functions))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn cfg_roundtrip() {
        let data = CfgData {
            module_name: "test_module".into(),
            functions: vec![
                CfgFunctionData {
                    name: "sub_140000000".into(),
                    entry_address: 0x140000000,
                    instruction_count: 42,
                    block_count: 3,
                },
                CfgFunctionData {
                    name: "sub_140001000".into(),
                    entry_address: 0x140001000,
                    instruction_count: 15,
                    block_count: 1,
                },
            ],
        };

        let buf = serialize_cfg(&data).expect("serialize falhou");

        // Verificar file identifier
        assert_eq!(&buf[4..8], b"HCFG");

        let decoded = deserialize_cfg(&buf).expect("deserialize falhou");
        assert_eq!(decoded.module_name, data.module_name);
        assert_eq!(decoded.functions.len(), 2);
        assert_eq!(decoded.functions[0].name, "sub_140000000");
        assert_eq!(decoded.functions[0].entry_address, 0x140000000);
        assert_eq!(decoded.functions[0].instruction_count, 42);
        assert_eq!(decoded.functions[1].name, "sub_140001000");
    }

    #[test]
    fn cfg_read_function_name() {
        let data = CfgData {
            module_name: "mod".into(),
            functions: vec![CfgFunctionData {
                name: "main_func".into(),
                entry_address: 0x1000,
                instruction_count: 10,
                block_count: 1,
            }],
        };

        let buf = serialize_cfg(&data).unwrap();
        let name = read_cfg_function_name(&buf).unwrap();
        assert_eq!(name, Some("main_func".into()));
    }

    #[test]
    fn cfg_empty_returns_error() {
        let data = CfgData {
            module_name: "empty".into(),
            functions: vec![],
        };
        assert!(serialize_cfg(&data).is_err());
    }

    #[test]
    fn cfg_invalid_buffer() {
        assert!(deserialize_cfg(&[0, 0]).is_err());
        assert!(deserialize_cfg(&[0, 0, 0, 0, b'X', b'X', b'X', b'X']).is_err());
    }
}
