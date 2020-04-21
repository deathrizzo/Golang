#!/bin/sh

# wrap takes some output and wraps it in a collapsible markdown section if
# it's over $TF_ACTION_WRAP_LINES long.
wrap() {
  if [[ $(echo "$1" | wc -l) -gt ${TF_ACTION_WRAP_LINES:-20} ]]; then
    echo "
<details><summary>Show Output</summary>

\`\`\`diff
$1
\`\`\`

</details>
"
else
    echo "
\`\`\`diff
$1
\`\`\`
"
fi
}

set -e

cd "${TF_ACTION_WORKING_DIR:-.}"

set +e
OUTPUT=$(sh -c "TF_IN_AUTOMATION=true terraform plan -detailed-exitcode -no-color -input=false $*" 2>&1)
SUCCESS=$?
echo "$OUTPUT"
set -e

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

COMMENT="#### \`terraform plan for $TF_ACTION_WORKING_DIR\`
$OUTPUT

*Workflow: \`$GITHUB_WORKFLOW\`, Action: \`$GITHUB_ACTION\`*"

echo "$COMMENT" > ${GITHUB_WORKSPACE}/tf_plan_output.txt
exit $SUCCESS
