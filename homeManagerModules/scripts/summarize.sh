#!/bin/bash

load_claude_settings() {
	local settings_file="$HOME/.claude/settings.json"

	if [ -f "$settings_file" ] && command -v jq &>/dev/null; then
		# Extract values from the settings file
		local file_auth_token
		file_auth_token=$(jq -r '.env.ANTHROPIC_AUTH_TOKEN // empty' "$settings_file" 2>/dev/null)
		local file_base_url
		file_base_url=$(jq -r '.env.ANTHROPIC_BASE_URL // empty' "$settings_file" 2>/dev/null)
		local file_sonnet_model
		file_sonnet_model=$(jq -r '.env.ANTHROPIC_DEFAULT_SONNET_MODEL // empty' "$settings_file" 2>/dev/null)

		# Set variables with priority: env > file > default
		ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN:-${file_auth_token}}"
		ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-${file_base_url:-https://api.anthropic.com}}"
		ANTHROPIC_DEFAULT_SONNET_MODEL="${ANTHROPIC_DEFAULT_SONNET_MODEL:-${file_sonnet_model:-claude-sonnet-4-5}}"
	else
		# Use defaults if no settings file or jq not available
		ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL:-https://api.anthropic.com}"
		ANTHROPIC_DEFAULT_SONNET_MODEL="${ANTHROPIC_DEFAULT_SONNET_MODEL:-claude-sonnet-4-5}"
	fi
}

load_claude_settings

if [ -z "$ANTHROPIC_AUTH_TOKEN" ]; then
	echo "Error: ANTHROPIC_AUTH_TOKEN environment variable is not set" >&2
	echo "Please set it with: export ANTHROPIC_AUTH_TOKEN='your-api-key'" >&2
	exit 1
fi

# Check if jq is available
if ! command -v jq &>/dev/null; then
	echo "Error: jq is required but not installed" >&2
	exit 1
fi

# Check if curl is available
if ! command -v curl &>/dev/null; then
	echo "Error: curl is required but not installed" >&2
	exit 1
fi

# Initialize variables
custom_command=""
text=""

# Parse command line arguments
parse_args() {
	while [[ $# -gt 0 ]]; do
		case $1 in
		--command | -c)
			custom_command="$2"
			shift 2
			;;
		--help | -h)
			show_help
			exit 0
			;;
		*)
			# Treat remaining arguments as text to process
			text="$text$1 "
			shift
			;;
		esac
	done
}

# Show help message
show_help() {
	echo "Usage: $0 [OPTIONS] <text to summarize>"
	echo "   or: cat file.txt | $0 [OPTIONS]"
	echo ""
	echo "OPTIONS:"
	echo "  -c, --command <command>  Custom command/question to ask about the text"
	echo "  -h, --help              Show this help message"
	echo ""
	echo "Configuration priority (highest to lowest):"
	echo "  1. Environment variables"
	echo "  2. ~/.claude/settings.json"
	echo "  3. Default values"
	echo ""
	echo "Environment variables:"
	echo "  ANTHROPIC_AUTH_TOKEN           - Required: Your Anthropic API key"
	echo "  ANTHROPIC_BASE_URL             - Optional: API base URL"
	echo "  ANTHROPIC_DEFAULT_SONNET_MODEL - Optional: Model to use"
	echo ""
	echo "Examples:"
	echo "  $0 \"This is a long text to summarize\""
	echo "  cat document.txt | $0"
	echo "  $0 -c \"What were the ingredients?\" \"The recipe calls for flour, sugar, eggs...\""
	echo "  cat recipe.txt | $0 --command \"Extract the cooking instructions\""
	echo ""
	echo "Current settings:"
	echo "  API Key: $([ -n "$ANTHROPIC_AUTH_TOKEN" ] && echo "***$(echo "$ANTHROPIC_AUTH_TOKEN" | tail -c 5)" || echo "not set")"
	echo "  Base URL: $ANTHROPIC_BASE_URL"
	echo "  Model: $ANTHROPIC_DEFAULT_SONNET_MODEL"
}

# Check if input is from pipe or arguments
if [ -t 0 ]; then
	# Input from arguments
	if [ $# -eq 0 ]; then
		show_help
		exit 1
	fi
	parse_args "$@"
	# Remove trailing space from text
	text="${text% }"
else
	# Input from pipe
	text=$(cat)
	# Parse any remaining arguments when using pipe
	parse_args "$@"
fi

# Check if text is empty
if [ -z "$text" ]; then
	echo "Error: No text provided to process" >&2
	exit 1
fi

summarize_text() {
	local text="$1"
	local command="$2"

	# Escape the text for JSON
	local escaped_text
	escaped_text=$(echo "$text" | jq -Rs .)

	# Create the prompt - always include summary, add custom command if provided
	local prompt="Please provide a concise summary of the following text.".
	if [ -n "$command" ]; then
		prompt="$prompt. $command"
	fi

	# Create JSON payload using jq
	local json_payload
	json_payload=$(jq -n \
		--arg model "$ANTHROPIC_DEFAULT_SONNET_MODEL" \
		--arg prompt "$prompt" \
		--arg text "$escaped_text" \
		'{
            model: $model,
            max_tokens: 1024,
            messages: [
                {
                    role: "user",
                    content: $prompt
                },
                {
                    role: "user",
                    content: $text
                }
            ]
        }')

	curl -s "${ANTHROPIC_BASE_URL}/v1/messages" \
		-H "Content-Type: application/json" \
		-H "x-api-key: ${ANTHROPIC_AUTH_TOKEN}" \
		-H "anthropic-version: 2023-06-01" \
		-d "$json_payload" | jq -r '.content[0].text'
}

# Summarize the text with optional custom command
summarize_text "$text" "$custom_command"
