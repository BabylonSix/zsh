# check if $SHELL has the word zsh in it
if [[ $SHELL == *zsh* ]]; then
  # zsh is the default shell
  zshDefault=true
else
  # zsh is not the default shell
  zshDefault=false
fi


rnmr() {
    # Enable null_glob for this function
    setopt local_options null_glob

    # Associative array for flags and an array for directories
    typeset -A opts
    typeset -a dirs
    opts=(--cd false --pd false --pre false --post false)

    # Parse the flags and directories
    for arg in "$@"; do
        if [[ $arg == --* ]]; then
            if [[ -n $opts[$arg] ]]; then
                opts[$arg]=true
            else
                print "${RED}Unknown option: $arg${NC}"
                return 1
            fi
        else
            dirs+=("$arg")
        fi
    done

    # Check if any directories are provided
    if [ ${#dirs[@]} -eq 0 ]; then
        print "${RED}No directory specified.${NC}"
        return 1
    fi

    # Store the current directory to return later
    local current_dir="$(pwd)"

    for dir in "${dirs[@]}"; do
        if [[ -d $dir ]]; then
            cd "$dir" || continue
            local dir_name="$( [[ ${opts[--pd]} == true ]] && basename "$(dirname "$PWD")" || basename "$PWD" )"

            # Loop through files and rename
            for file in *(.); do
                if [[ ${opts[--post]} == true ]]; then
                    mv "$file" "${file} - ${dir_name}"
                else
                    mv "$file" "${dir_name} - ${file}"
                fi
            done
            cd "$current_dir"
        else
            print "${RED}Directory not found: $dir${NC}"
        fi
    done
}


txtsplit() {
    # Check for the -c flag for case sensitivity
    local case_sensitive=0
    if [[ $1 == "-c" ]]; then
        case_sensitive=1
        shift
    fi

    # Assign the text delimiter and the file to be processed
    local delimiter="$1"
    local file="$2"
    local output_file=""
    local in_block=0

    # Check if the file exists
    if [[ ! -f "$file" ]]; then
        echo "File not found: $file"
        return 1
    fi


# Usage: txtsplit "text-delimiter" "file-to-be-split.txt"
# With -c flag for case sensitivity: txtsplit -c "Text-Delimiter" "file-to-be-split.txt"
