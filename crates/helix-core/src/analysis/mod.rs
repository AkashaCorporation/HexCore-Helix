//! Analysis passes for the decompilation pipeline.
//!
//! These modules perform data flow analysis, type inference,
//! calling convention recovery, variable recovery, control flow
//! structuring, and HIR validation on the HIR before final code emission.

pub mod calling_convention;
pub mod control_flow;
pub mod data_flow;
pub mod type_propagation;
pub mod validation;
