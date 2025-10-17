require 'rugged'

path = "./tmp/repos/1/UkLWZg9DAJQ7XlrzYPhmv/"

# Load the repository
repo = Rugged::Repository.new(path)


## Playing around with diffs

# 1. Diffs between two commits
last_commit = repo.references["refs/heads/main"].target

last_commit.parents[0].diff(last_commit)

diff = last_commit.diff(last_commit.parents[0])

diff.each_delta do |delta|
  puts delta.inspect
end
