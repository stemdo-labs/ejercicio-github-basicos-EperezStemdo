
# Extraer el título del pull request
title=$(gh pr view --json title --jq '.title')

# Crear la issue
gh issue create --title "Issue relacionada con el PR: $title" --body "Esta issue está relacionada con el pull request: $title"

# Autoasignarse la issue
gh issue list --limit 1 --state open --jq '.[].number' | xargs -I {} gh issue update {} --assignee $(gh api user | jq -r '.login')

# Obtener el número de la issue recién creada
issue_number=$(gh issue list --limit 1 --state open --jq '.[].number')

# Agregar una referencia a la pull request en la issue
gh issue comment $issue_number --body "Referencia a la pull request: $(gh pr view --json html_url --jq '.html_url')"

# Cerrar la issue automáticamente al cerrar el pull request
echo "::set-output name=issue_number::$issue_number"
