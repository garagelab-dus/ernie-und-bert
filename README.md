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

## git status inklusive submodule

`git status` zeigt keine Veränderungen der Submodule an. Erst mit dem nächsten Eintrag in die `git config` werden auch Submodule angezeigt.

```shell
git config status.submodulesummary 1
```

```text
(robot) lerobot@GarageLab-MacBook-Air-No1-3 ernie-und-bert % git status          
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean



(robot) lerobot@GarageLab-MacBook-Air-No1-3 ernie-und-bert % git config status.submodulesummary 1
(robot) lerobot@GarageLab-MacBook-Air-No1-3 ernie-und-bert % git status                          
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
  (commit or discard the untracked or modified content in submodules)
	modified:   protolab-docs (modified content). <-- Änderung im Submodule !

no changes added to commit (use "git add" and/or "git commit -a")
```
