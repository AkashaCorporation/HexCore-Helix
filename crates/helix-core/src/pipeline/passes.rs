//! Built-in transform passes for the decompilation pipeline.
//!
//! Each pass implements the [`TransformPass`] trait and operates
//! on either the CFG or the AST representation.

use crate::ast::AstNode;
use crate::error::HelixError;
use crate::pipeline::{PassInfo, TransformPass};
use crate::types::ControlFlowGraph;

// ─── Dead Block Elimination ─────────────────────────────────────────────────

/// Removes basic blocks that are unreachable from the entry point.
pub struct DeadBlockElimination;

impl TransformPass for DeadBlockElimination {
    fn info(&self) -> PassInfo {
        PassInfo {
            id: "helix.dead-block-elimination".to_string(),
            description: "Remove unreachable basic blocks from the CFG".to_string(),
            is_parallelizable: false,
        }
    }

    fn transform_cfg(&self, mut cfg: ControlFlowGraph) -> Result<ControlFlowGraph, HelixError> {
        if cfg.blocks.is_empty() {
            return Ok(cfg);
        }

        // BFS from entry block to find reachable blocks
        let mut reachable = std::collections::HashSet::new();
        let mut queue = std::collections::VecDeque::new();

        reachable.insert(cfg.entry);
        queue.push_back(cfg.entry);

        while let Some(addr) = queue.pop_front() {
            if let Some(block) = cfg.blocks.iter().find(|b| b.start == addr) {
                for edge in &block.successors {
                    if reachable.insert(edge.target) {
                        queue.push_back(edge.target);
                    }
                }
            }
        }

        let original_count = cfg.blocks.len();
        cfg.blocks.retain(|b| reachable.contains(&b.start));

        if cfg.blocks.len() < original_count {
            // Blocks were removed — this is a successful optimization
        }

        Ok(cfg)
    }
}

// ─── Empty Block Merge ──────────────────────────────────────────────────────

/// Merges consecutive basic blocks that have a single unconditional edge
/// between them (i.e., block A has one successor B, and B has one predecessor A).
pub struct EmptyBlockMerge;

impl TransformPass for EmptyBlockMerge {
    fn info(&self) -> PassInfo {
        PassInfo {
            id: "helix.empty-block-merge".to_string(),
            description: "Merge linear chains of basic blocks".to_string(),
            is_parallelizable: false,
        }
    }

    fn transform_cfg(&self, mut cfg: ControlFlowGraph) -> Result<ControlFlowGraph, HelixError> {
        // Count predecessors for each block
        let mut pred_count: std::collections::HashMap<crate::types::Address, usize> =
            std::collections::HashMap::new();

        for block in &cfg.blocks {
            for edge in &block.successors {
                *pred_count.entry(edge.target).or_insert(0) += 1;
            }
        }

        // Find merge candidates: blocks with exactly one unconditional successor
        // whose successor has exactly one predecessor
        let mut merged = true;
        while merged {
            merged = false;
            let mut i = 0;
            while i < cfg.blocks.len() {
                if cfg.blocks[i].successors.len() == 1
                    && cfg.blocks[i].successors[0].kind
                        == crate::types::CfgEdgeKind::Unconditional
                {
                    let target = cfg.blocks[i].successors[0].target;
                    if pred_count.get(&target).copied().unwrap_or(0) == 1 {
                        // Find the target block
                        if let Some(target_idx) =
                            cfg.blocks.iter().position(|b| b.start == target)
                        {
                            if target_idx != i {
                                let target_block = cfg.blocks.remove(
                                    if target_idx > i {
                                        target_idx
                                    } else {
                                        // Adjust if target was before current
                                        i -= 1;
                                        target_idx
                                    },
                                );
                                cfg.blocks[i]
                                    .instructions
                                    .extend(target_block.instructions);
                                cfg.blocks[i].end = target_block.end;
                                cfg.blocks[i].successors = target_block.successors;
                                merged = true;
                                continue;
                            }
                        }
                    }
                }
                i += 1;
            }
        }

        Ok(cfg)
    }
}

// ─── Comment Injection Pass ─────────────────────────────────────────────────

/// Injects helpful comments into the AST (address cross-references,
/// decompiler notes, etc.).
pub struct CommentInjection;

impl TransformPass for CommentInjection {
    fn info(&self) -> PassInfo {
        PassInfo {
            id: "helix.comment-injection".to_string(),
            description: "Add address cross-references and decompiler notes".to_string(),
            is_parallelizable: true,
        }
    }

    fn transform_ast(&self, ast: AstNode) -> Result<AstNode, HelixError> {
        // Currently a no-op — will inject xref comments when the
        // cross-reference database is available (Phase 4)
        Ok(ast)
    }
}

/// Returns the default set of transform passes for the decompilation pipeline.
pub fn default_passes() -> Vec<Box<dyn TransformPass>> {
    vec![
        Box::new(DeadBlockElimination),
        Box::new(EmptyBlockMerge),
        Box::new(CommentInjection),
    ]
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::types::*;

    #[test]
    fn dead_block_elimination_keeps_reachable() {
        let cfg = ControlFlowGraph {
            name: "test".to_string(),
            entry: Address(0x100),
            arch: ArchKind::X86_64,
            blocks: vec![
                BasicBlock {
                    start: Address(0x100),
                    end: Address(0x110),
                    instructions: Vec::new(),
                    successors: vec![CfgEdge {
                        source: Address(0x100),
                        target: Address(0x110),
                        kind: CfgEdgeKind::Unconditional,
                    }],
                },
                BasicBlock {
                    start: Address(0x110),
                    end: Address(0x120),
                    instructions: Vec::new(),
                    successors: Vec::new(),
                },
                // Unreachable block
                BasicBlock {
                    start: Address(0x200),
                    end: Address(0x210),
                    instructions: Vec::new(),
                    successors: Vec::new(),
                },
            ],
        };

        let pass = DeadBlockElimination;
        let result = pass.transform_cfg(cfg).unwrap();

        assert_eq!(result.blocks.len(), 2);
        assert!(result.blocks.iter().all(|b| b.start != Address(0x200)));
    }

    #[test]
    fn default_passes_returns_expected_count() {
        let passes = default_passes();
        assert_eq!(passes.len(), 3);
        assert_eq!(passes[0].info().id, "helix.dead-block-elimination");
        assert_eq!(passes[1].info().id, "helix.empty-block-merge");
        assert_eq!(passes[2].info().id, "helix.comment-injection");
    }
}
