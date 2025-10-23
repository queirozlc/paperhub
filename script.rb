require 'json'
require 'rugged'

path = "./tmp/repos/1/p6klVeMgbnWYyI4Gvz7fw"

# Load the repository
repo = Rugged::Repository.new(path)

index = repo.index

## Playing around with diffs

# 1. Diffs between two commits
last_commit = repo.references["refs/heads/teste"].target
diff = last_commit.parents.first.diff(last_commit)
puts diff.patch
