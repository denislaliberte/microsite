Create a git commit using the standard commit template with proper formatting.

This command will:
1. Check git status and show staged changes
2. Create a commit message file based on the commit template
3. Guide you through filling out the required sections
4. Execute the git commit with the formatted message

Usage: Use this command when you're ready to commit staged changes and want to follow the project's commit message standards.

---

I'll help you create a commit following the project template. Let me first check the current git status and then create the commit message.

First, let me check what's staged for commit:

```bash
git status
git diff --cached --stat
```

Now I'll create a commit message based on the template at `.specify/templates/commit-template.md`. 

Please provide:
1. **Brief summary**: What was accomplished in this commit?
2. **What**: Single line describing the high-level change
3. **Why**: Business/technical rationale (1-2 sentences) 
4. **How to Test**: Manual testing steps to verify this change works

I'll format this into a proper commit message and execute `git commit -F <message-file>`.