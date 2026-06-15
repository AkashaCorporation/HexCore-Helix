use helix_core::error::HelixStatus;
use helix_core::ArchKind;
use std::mem;

#[test]
fn arch_kind_stays_ffi_stable() {
    assert_eq!(mem::size_of::<ArchKind>(), 1);

    assert_eq!(ArchKind::X86 as u8, 0);
    assert_eq!(ArchKind::X86_64 as u8, 1);
    assert_eq!(ArchKind::Arm as u8, 2);
    assert_eq!(ArchKind::Aarch64 as u8, 3);
    assert_eq!(ArchKind::Mips as u8, 4);
    assert_eq!(ArchKind::Mips64 as u8, 5);
    assert_eq!(ArchKind::PowerPc as u8, 6);
    assert_eq!(ArchKind::PowerPc64 as u8, 7);
    assert_eq!(ArchKind::Sparc as u8, 8);
    assert_eq!(ArchKind::Sparc64 as u8, 9);
    assert_eq!(ArchKind::Riscv32 as u8, 10);
    assert_eq!(ArchKind::Riscv64 as u8, 11);
}

#[test]
fn status_codes_stay_ffi_stable() {
    assert_eq!(HelixStatus::Ok as i32, 0);
    assert_eq!(HelixStatus::ErrorInvalidInput as i32, -1);
    assert_eq!(HelixStatus::ErrorUnsupportedArch as i32, -2);
    assert_eq!(HelixStatus::ErrorLiftFailed as i32, -3);
    assert_eq!(HelixStatus::ErrorTransformFailed as i32, -4);
    assert_eq!(HelixStatus::ErrorEmitFailed as i32, -5);
    assert_eq!(HelixStatus::ErrorOutOfMemory as i32, -6);
    assert_eq!(HelixStatus::ErrorEngineNotReady as i32, -7);
    assert_eq!(HelixStatus::ErrorInternal as i32, -99);

    assert_eq!(HelixStatus::from(0), HelixStatus::Ok);
    assert_eq!(HelixStatus::from(-1), HelixStatus::ErrorInvalidInput);
    assert_eq!(HelixStatus::from(-2), HelixStatus::ErrorUnsupportedArch);
    assert_eq!(HelixStatus::from(-3), HelixStatus::ErrorLiftFailed);
    assert_eq!(HelixStatus::from(-4), HelixStatus::ErrorTransformFailed);
    assert_eq!(HelixStatus::from(-5), HelixStatus::ErrorEmitFailed);
    assert_eq!(HelixStatus::from(-6), HelixStatus::ErrorOutOfMemory);
    assert_eq!(HelixStatus::from(-7), HelixStatus::ErrorEngineNotReady);
    assert_eq!(HelixStatus::from(-99), HelixStatus::ErrorInternal);
    assert_eq!(HelixStatus::from(-1234), HelixStatus::ErrorInternal);
}
