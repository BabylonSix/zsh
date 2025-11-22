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


########################################################################
# Script Name: list_files.zsh
# Description: A Zsh script for directory listing with clipboard support.
# 
# Usage: Execute with flags (e.g., ./list_files.zsh --cd)
# Environment: macOS with Zsh
#
########################################################################
#
# CURRENT CAPABILITIES
# --------------------
#   --cd Flag:
#     - Lists all files and directories in the current directory.
#     - Formats directories with a trailing slash.
#     - Copies the formatted list to the macOS clipboard.
#
# EXPANDABILITY
# -------------
#   - Structured with a 'case' statement for easy addition of new flags.
#   - Each flag can trigger specific commands for extended functionality.
#
# USAGE NOTES
# -----------
#   - Run the script with desired flags to execute corresponding actions.
#   - Example: './list_files.zsh --cd' lists contents of the current directory.
#
# ENVIRONMENT
# -----------
#   - Designed for Zsh in a macOS environment.
#   - Utilizes 'pbcopy' for clipboard interaction.
#
########################################################################

copy() {
  for arg in "$@"; do
    case "$arg" in
      --cd)
        for file in *(D); do
          if [[ -d $file ]]; then
            echo "$file/"
          else
            echo "$file"
          fi
        done | pbcopy
        ;;
      
      # Template for additional flags
      # --other-flag)
      #   # Implement other flag's functionality
      #   ;;

      *)
        echo "Invalid flag: $arg"
        ;;
    esac
  done
}

split_txt() {
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

    # Process the file using awk
    awk -v delimiter="$delimiter" -v case_sensitive="$case_sensitive" '
    BEGIN {IGNORECASE=(case_sensitive==0)}
    {
        if ((IGNORECASE && tolower($0) ~ tolower(delimiter)) || (!IGNORECASE && $0 ~ delimiter)) {
            in_block = 0
            if (output_file != "") {
                close(output_file)
            }
            output_file = ""
            next
        }

        if (in_block == 0 && $0 !~ /^[[:space:]]*$/) {
            gsub(/[\/]/, "_", $0)
            output_file = $0 ".txt"
            in_block = 1
        }

        if (in_block == 1 && output_file != "") {
            print $0 > output_file
        }
    }
    END {
        if (output_file != "") {
            close(output_file)
        }
    }' "$file"
}

# Usage: split_txt "text-delimiter" "file-to-be-split.txt"
# With -c flag for case sensitivity: split_txt -c "Text-Delimiter" "file-to-be-split.txt"
