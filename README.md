# To run the tests

Fetch and build all firmware.
```
nix-build ./bao-tests-firmware/test-VM.nix
```

---

Run qemu
```
./bao-tests-firmware/run_qemu.sh
> go 0x50000000
```

---
