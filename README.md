# Willkommen bei Ernie und Bert

Dieses Repository enthält Dateien, die wir beim der Arbeit mit unseren Robotern nutzen.

---

## git LFS Installieren

Dieses Repository enthält große Dateien (> 50MB), die mit `git-lfs` verarbeitet werden.

```bash
# visit gh.io/lfs
git lfs install
git lfs track "*.safetensors"
git lfs track "*.tgz"
```

Siehe auch `.gitattributes`

---

Dieses Repository enthält `Submodule`.

## Klonen inklusive Submodule

```shell
git clone --recurse-submodules https://github.com/garagelab-dus/ernie-und-bert.git
```
