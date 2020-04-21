#!/bin/sh

# wrap takes some output and wraps it in a collapsible markdown section
wrap() {
  echo "
<details><summary>Show Output</summary>

\`\`\`diff
$1
\`\`\`

</details>
"
}

set -e

cd "${TF_ACTION_WORKING_DIR:-.}"

if [[ ! -z "$TF_ACTION_TFE_TOKEN" ]]; then
  cat > ~/.terraformrc << EOF
credentials "${TF_ACTION_TFE_HOSTNAME:-app.terraform.io}" {
  token = "$TF_ACTION_TFE_TOKEN"
}
EOF
fi

if [[ ! -z "$TF_ACTION_WORKSPACE" ]] && [[ "$TF_ACTION_WORKSPACE" != "default" ]]; then
  terraform workspace select "$TF_ACTION_WORKSPACE"
fi

set +e
OUTPUT=$(sh -c "TF_IN_AUTOMATION=true terraform plan -no-color -detailed-exitcode -input=false $*" 2>&1)
SUCCESS=$?
echo "$OUTPUT"
set -e

if [ "$TF_ACTION_COMMENT" = "1" ] || [ "$TF_ACTION_COMMENT" = "false" ]; then
    exit $SUCCESS
fi

# Build the comment we'll post to the PR.
COMMENT=""
if [ $SUCCESS -ne 0 ] && [ $SUCCESS -ne 2 ]; then
    OUTPUT=$(wrap "$OUTPUT")
    COMMENT="#### \`terraform plan\` Failed for \`$TF_ACTION_WORKING_DIR\`
$OUTPUT

*Workflow: \`$GITHUB_WORKFLOW\`, Action: \`$GITHUB_ACTION\`*"
else
    # Remove "Refreshing state..." lines by only keeping output after the
    # delimiter (72 dashes) that represents the end of the refresh stage.
    # We do this to keep the comment output smaller.
    if echo "$OUTPUT" | egrep '^-{72}$'; then
        OUTPUT=$(echo "$OUTPUT" | sed -n -r '/-{72}/,/-{72}/{ /-{72}/d; p }')
    fi

    # Remove whitespace at the beginning of the line for added/modified/deleted
    # resources so the diff markdown formatting highlights those lines.
    OUTPUT=$(echo "$OUTPUT" | sed -r -e 's/^  \+/\+/g' | sed -r -e 's/^  ~/~/g' | sed -r -e 's/^  -/-/g')

    # Call wrap to optionally wrap our output in a collapsible markdown section.
    OUTPUT=$(wrap "$OUTPUT")

    COMMENT="#### \`terraform plan\` Success for \`$TF_ACTION_WORKING_DIR\`
$OUTPUT

*Workflow: \`$GITHUB_WORKFLOW\`, Action: \`$GITHUB_ACTION\`*"
fi

comment() {
  # Post the comment.
  PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
  COMMENTS_URL=$(cat $GITHUB_EVENT_PATH | jq -r .pull_request.comments_url)
  curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null
}

if [ "$TF_SKIP_COMMENT_IF_NO_CHANGES" ]; then
  if [ $SUCCESS -ne 0 ]; then
    comment
  fi
else
  comment
fi

if [ $SUCCESS -eq 0 ] || [ $SUCCESS -eq 2 ]; then
	SUCCESS=0
fi

exit $SUCCESS
