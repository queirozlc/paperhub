require 'rugged'
require 'json'

path = "./tmp/repos/1/VqXmZF31wYIqpkviO5nCz"

# Load the repository
repo = Rugged::Repository.new(path)

index = repo.index

## Playing around with diffs

# 1. Diffs between two commits
# last_commit = repo.references["refs/heads/main"].target
# diff = last_commit.parents.first.diff(last_commit)
diff = repo.diff_from_buffer(JSON.generate({ type: "doc", content: [] }))
# puts diff.inspect
puts diff.inspect
