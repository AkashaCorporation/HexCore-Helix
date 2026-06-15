//! # HexCore Helix — NAPI-RS Bridge
//!
//! This crate is the **only** boundary between the Helix engine and Node.js/V8.
//! It wraps `helix-core` types into NAPI-safe classes and functions.
//!
//! **Design rule**: No business logic here — only marshalling.

#![deny(clippy::all)]

mod engine;
mod transport;

pub use engine::HelixEngine;
