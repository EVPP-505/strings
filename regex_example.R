
#This script is meant illustrate how to use regular expressions (regex) to find
# portions of a string.  We are interested in finding portions of a sting between
# two boundaries in this case.

#first set the working directory
parent_dir <- "~/Dropbox (Smithsonian)/si-r-class/tree-properties"
# knitr:::input_dir()
setwd(parent_dir)

#set up the file paths to the two directories we want to work with.
# the file.path function is meant to be platform independent, so there is no need to worry
# about the direction of the slash.
trees_dir <- file.path(parent_dir, "trees")
aln_dir <- file.path(parent_dir, "alignments")

#build a list of the files from each directory
trees_files <- list.files(path=trees_dir, pattern="*tre")
aln_files <- list.files(path=aln_dir, pattern="*fasta")

#this is the regex to find the portion of the files names we want
# the files are named like: Assembly_carttincxEL411208.fasta
# we want the portion after the _ but before the first .
# we use one of the file lists to build the matches, assuming the tree_files is a complete list of 
# all the files we would work with.  The perl=TRUE makes the underlying perl libraries are accessible
r <- regexpr("(?<=_)[a-zA-Z0-9]+(?=\\.)", trees_files, perl = TRUE)

# (?<=_) is what's called a lookbehind.  This looks for everything up to (or behind) the _
# [a-zA-Z0-9]+ the letters and numbers in the [] tell the expression to look for any alphanumeric
# character and the + is to match this one or more times
# (?=\\.) is a lookahead, which looks for everything after the first .

# together this expression looks for any character after the _ one or more times until it reaches the .
# we can see the matches using the function regmatches
matches <- regmatches(trees_files, r)
print(matches)

# now that we have a vector of unique file identifiers, try looping over the vector
# and extract the matching files from each list.
for (m in matches){
  #use []-notation indexing to extract the matching file names from each list
  tree <- trees_files[grep(m, trees_files)]
  aln <- aln_files[grep(m, aln_files)]
  
  # build the file paths
  print(file.path(trees_dir,tree))
  print(file.path(aln_dir, aln))
}

