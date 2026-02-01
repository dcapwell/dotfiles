#!/usr/bin/env bash

#set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

_main() {
  local model=qwen3:30b
  local prompt='You are analyzing a document to create comprehensive summaries.

Provide a detailed summary with the following structure:

**Summary**: A 2-3 sentence overview of what this document is about

**Key Points**:
- List the main discussion points, decisions, or information shared
- Include relevant context and background

**Action Items**:
- [ ] Clearly list any tasks, requests, or commitments made (especially those directed at you)
- Include deadlines or timeframes where mentioned
- Note who is responsible for each action
- If none, state "No action items"

**Questions for You**:
- List any direct questions that need your response
- Include questions that are implied or need clarification
- If none, state "No questions pending"

**Decisions Made**:
- Document any conclusions, agreements, or resolutions reached
- Note if consensus was achieved or if there are open disagreements
- If none, state "No decisions made"

**Priority/Urgency**: [High/Medium/Low] - Based on deadlines, explicit urgency markers, or importance of participants

**Recommended Response**: [Required/Optional/None] - Whether and why you should respond

---

Format your output in clean, scannable markdown. Be concise but dont omit important details.'
  while [ $# -gt 0 ]; do
    case "$1" in
      -m|--model)
        model="$2"
        shift 2
        ;;
      *)
        break
        ;;
    esac
  done

  ollama run --hidethinking "$model" "$prompt"
}

_main "$@"
