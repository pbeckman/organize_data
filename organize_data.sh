# run this script from your terminal using a command like
# >> bash ~/Documents/organize_data.sh ~/Downloads/2_V2_BACKWARD/uploads

# the first argument after the `bash` command should point to the location of this script
# the second argument should point to the folder containing your data
# make sure your target directory doesn't have spaces in the name

# if you get an error like this:
# >> organize_data.sh: line 23: syntax error near unexpected token `do
# you may have edited the file with an incompatible text editor :(

### ###

# change these variables according to your experiment :)

# make list variables containing associated IDs
# lists are declared with parantheses and no commas
sentence_recall=("fwhp")
NWR=("624x")
p_b_id=("f4p8")
test_exposure=("6m56")

# make list of the above variable names
tasks=("sentence_recall" "NWR" "p_b_id" "test_exposure")

### ###

# you shouldn't have to change anything after this comment

directory=${1%/}

for file in $directory/*; do
  # trim folders from beginning of file name
  file=$(basename $file)
  # make participant variable based on file name
  participant=$([[ file =~ (?:[^-]*-){2}([^-]*) ]] && echo "${BASH_REMATCH[0]}")

  # make directory for each participant
  if [ ! -d $directory/$participant ]; then
    mkdir $directory/$participant
  fi
  
  # move file to participant directory
  if [[ $file =~ (?:[^-]*-){2}$participant ]]; then
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
        if [[ $file =~ (?:[^-]*-){4}$id ]]; then
          mv $participant_dir/$file $participant_dir/$task
        fi
      done
    done
  done
done
