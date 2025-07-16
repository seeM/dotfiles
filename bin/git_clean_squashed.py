# Based on https://github.com/not-an-aardvark/git-delete-squashed/blob/master/bin/git-delete-squashed.js
import subprocess
import sys

DEFAULT_BRANCH = "main"


def git(*args):
    proc = subprocess.run(
        ["git", *args],
        capture_output=True,
        check=True,
        encoding="utf8",
    )
    return proc.stdout.strip()


branches = git("for-each-ref", "refs/heads/", "--format=%(refname:short)").split("\n")
if DEFAULT_BRANCH not in branches:
    print(f"Default branch '{DEFAULT_BRANCH}' not found in repo.", file=sys.stderr)
    sys.exit(1)

branches_to_delete = []
for branch in branches:
    # Get the common ancestor with the branch and the default branch.
    print(branch)
    try:
        ancestor_hash = git("merge-base", DEFAULT_BRANCH, branch)
    except:
        branches_to_delete.append(branch)
        continue
    tree_id = git("rev-parse", f"{branch}^{{tree}}")
    print(repr(ancestor_hash))
    print(repr(tree_id))
    dangling_commit_id = git(
        "commit-tree", tree_id, "-p", ancestor_hash, "-m", f"Temp commit for {branch}"
    )
    print(repr(dangling_commit_id))
    output = git("cherry", DEFAULT_BRANCH, dangling_commit_id)
    print(repr(output))
    if not output.startswith("-"):
        continue
    # Delete the branch
    # git("checkout", branch)
    # output = git("branch", "-D", branch)
    # print(output)
    branches_to_delete.append(branch)

print(f"Deleting {len(branches_to_delete)} branches:")
for branch in branches_to_delete:
    # git("checkout", branch)
    output = git("branch", "-D", branch)
    print(output)
