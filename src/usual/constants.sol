// SPDX-License-Identifier: Apache-2.0

pragma solidity 0.8.26;

// The default admin role.
bytes32 constant DEFAULT_ADMIN_ROLE = 0x00;

// The unwrap role. Required to unwrap UsualUSDTB.
bytes32 constant USUAL_USDTB_UNWRAP = keccak256("USUAL_USDTB_UNWRAP");

// The pause role. Required to pause UsualUSDTB.
bytes32 constant USUAL_USDTB_PAUSE = keccak256("USUAL_USDTB_PAUSE");

// The unpause role. Required to unpause UsualUSDTB.
bytes32 constant USUAL_USDTB_UNPAUSE = keccak256("USUAL_USDTB_UNPAUSE");

// The blacklist role. Required to blacklist addresses.
bytes32 constant BLACKLIST_ROLE = keccak256("BLACKLIST_ROLE");

// The mint cap allocator role. Required to set the mint cap.
bytes32 constant USUAL_USDTB_MINTCAP_ALLOCATOR = keccak256("USUAL_USDTB_MINTCAP_ALLOCATOR");
