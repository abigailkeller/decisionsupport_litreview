################
# clean file 1 #
################

# 1. Read the file safely despite the locale issues
raw_lines1 <- readLines("data/decisionsupport_refs1.ris", 
                        encoding = "latin1", warn = FALSE)
raw_lines1 <- iconv(raw_lines1, from = "latin1", to = "UTF-8", sub = "")

# 2. Identify where records start (TY  -) and end (ER  -)
starts1 <- which(grepl("^TY  -", raw_lines1))
ends1   <- which(grepl("^ER  -", raw_lines1))

# 3. Fix the mismatch
# We will only keep 'starts' that have a corresponding 'end' after them
valid_records1 <- data.frame(start = NA, end = NA)

for(i in seq_along(starts1)) {
  # Find the first 'end' that comes after this 'start'
  possible_end <- ends1[ends1 > starts1[i]][1]
  if(!is.na(possible_end)) {
    valid_records1[i, ] <- c(starts1[i], possible_end)
    # Remove that end from the list so it isn't used twice
    ends1 <- ends1[ends1 != possible_end]
  }
}

# Remove any failed matches (NAs)
valid_records1 <- na.omit(valid_records1)

# 4. Rebuild the cleaned file text
cleaned_content1 <- unlist(apply(valid_records1, 1, function(x) {
  c(raw_lines1[x[1]:x[2]])
}))

# 5. Write to a new file and read with synthesisr
writeLines(cleaned_content1, "data/decisionsupport_refs1_clean.ris")

################
# clean file 2 #
################

# 1. Read the file safely despite the locale issues
raw_lines2 <- readLines("data/decisionsupport_refs2.ris", 
                       encoding = "latin1", warn = FALSE)
raw_lines2 <- iconv(raw_lines2, from = "latin1", to = "UTF-8", sub = "")

# 2. Identify where records start (TY  -) and end (ER  -)
starts2 <- which(grepl("^TY  -", raw_lines2))
ends2   <- which(grepl("^ER  -", raw_lines2))

# 3. Fix the mismatch
# We will only keep 'starts' that have a corresponding 'end' after them
valid_records2 <- data.frame(start = NA, end = NA)

for(i in seq_along(starts2)) {
  # Find the first 'end' that comes after this 'start'
  possible_end <- ends2[ends2 > starts2[i]][1]
  if(!is.na(possible_end)) {
    valid_records2[i, ] <- c(starts2[i], possible_end)
    # Remove that end from the list so it isn't used twice
    ends2 <- ends2[ends2 != possible_end]
  }
}

# Remove any failed matches (NAs)
valid_records2 <- na.omit(valid_records2)

# 4. Rebuild the cleaned file text
cleaned_content2 <- unlist(apply(valid_records2, 1, function(x) {
  c(raw_lines2[x[1]:x[2]])
}))

# 5. Write to a new file and read with synthesisr
writeLines(cleaned_content2, "data/decisionsupport_refs2_clean.ris")


###############
# deduplicate #
###############

# import bibliographic information
data <- rbind(
  read_bibliography("data/decisionsupport_refs1_clean.ris"),
  read_bibliography("data/decisionsupport_refs2_clean.ris")
)

# locate and extract unique references
# removed three refs
# saved as "data/refs_deduplicated.rds"
duplicate_data <- screen_duplicates(data)
