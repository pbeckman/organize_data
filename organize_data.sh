# run this script from your terminal using
# >> bash path/to/script/organize_data.sh folder/with/data/
# where you replace `path/to/script/` and `folder/with/data/`
# with the relevant file locations

### ###

# change these variables according to your experiment

# make list variables containing associated IDs
# variable names should be just letters and underscores
# lists are declared with parantheses and no commas
sentence_recall=("i388" "4y4f")
NWR=("kv7i" "824j")
digit_span=("qofa" "ffsd")

# make list of the above variable names
tasks=("sentence_recall" "NWR" "digit_span")

### ###

# you shouldn't have to change anything after this comment :)

directory=${1%/}

for file in $directory/*; do
  # trim folders from beginning of file name
  file=$(basename $file)
  # make participant variable based on file name
  participant=$([[ $file =~ ([^-]*-){2}([^-]*) ]] && echo "${BASH_REMATCH[2]}")

  # make directory for each participant
  if [ ! -d $directory/$participant ]; then
    mkdir $directory/$participant
  fi
  
  # move file to participant directory
  if [[ $file =~ ([^-]*-){2}$participant ]]; then
    mv $directory/$file $directory/$participant
  fi
done

for participant_dir in $directory/*; do
  for task in ${tasks[@]}; do
    # make directory for each task
    if [ ! -d $participant_dir/$task ]; then
      mkdir $participant_dir/$task
    fi

    for id in $(eval echo \${$task[@]}); do
      for file in $participant_dir/*; do
        # trim folders from beginning of file name
        file=$(basename $file)

        # move file to task directory
        if [[ $file =~ ([^-]*-){4}$id ]]; then
          mv $participant_dir/$file $participant_dir/$task
        fi
      done
    done
  done
done

### ###

# if you have any issues,
# make sure your target directory doesn't have spaces in the name

# if you get an error like this:
# >> organize_data.sh: line 23: syntax error near unexpected token `do
# you may have edited this script with an incompatible text editor :(

# if something else breaks, text me ;)