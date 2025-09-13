# Constitution Update Checklist

When amending the constitution (`/memory/constitution.md`), ensure all dependent documents are updated to maintain consistency.

## Templates to Update

### When adding/modifying ANY article:
- [ ] `/templates/plan-template.md` - Update Constitution Check section
- [ ] `/templates/spec-template.md` - Update if requirements/scope affected
- [ ] `/templates/tasks-template.md` - Update if new task types needed
- [ ] `/.claude/commands/plan.md` - Update if planning process changes
- [ ] `/.claude/commands/tasks.md` - Update if task generation affected
- [ ] `/.claude/commands/prime.md` - Update project context and technical overview

### Article-specific updates:

#### Article I (Keep It Simple, Stupid - KISS):
- [ ] Emphasize simple, minimal maintenance solutions
- [ ] Update templates to favor open-source, batteries-included tools
- [ ] Add warnings against complex custom implementations
- [ ] Include reliable, well-established tool preferences

#### Article II (Text-Based):
- [ ] Ensure markdown format requirements in templates
- [ ] Add plain text format validation
- [ ] Include future-proofing reminders
- [ ] Update data portability requirements

#### Article III (Content-First):
- [ ] Emphasize content over UI/UX in templates
- [ ] Add readability enhancement guidelines
- [ ] Include visual element necessity checks
- [ ] Update accessibility and clarity requirements

#### Article IV (Test-First Development):
- [ ] Update test order in all templates (contract → integration → unit → implementation)
- [ ] Emphasize TDD requirements
- [ ] Add test approval gates before any production code
- [ ] Include "tests as living documentation" requirements
- [ ] Update validation workflows to require tests first

#### Article V (Excellent Record-Keeping):
- [ ] Add implementation log requirements to all phase templates
- [ ] Include commit message template usage requirements
- [ ] Update templates to emphasize real-time documentation
- [ ] Add architectural decision recording requirements
- [ ] Include pivot and problem documentation guidelines
- [ ] Update validation workflows to require logging compliance

## Validation Steps

1. **Before committing constitution changes:**
   - [ ] All templates reference new requirements
   - [ ] Examples updated to match new rules
   - [ ] No contradictions between documents

2. **After updating templates:**
   - [ ] Run through a sample implementation plan
   - [ ] Verify all constitution requirements addressed
   - [ ] Check that templates are self-contained (readable without constitution)

3. **Version tracking:**
   - [ ] Update constitution version number
   - [ ] Note version in template footers
   - [ ] Add amendment to constitution history

## Common Misses

Watch for these often-forgotten updates:
- Command documentation (`/commands/*.md`)
- Checklist items in templates
- Example code/commands
- Domain-specific variations (web vs mobile vs CLI)
- Cross-references between documents

## Template Sync Status

Last sync check: 2025-09-12
- Constitution version: 1.2.0 (added Article V - Excellent Record-Keeping)
- Templates aligned: ⚠️ (need updates for v1.2.0 - Article V requirements)

### Article V Implementation Status:
- [✅] Phase templates: Implementation log warnings added
- [✅] Prime command: Logging and commit requirements documented
- [✅] Commit template: Created with proper structure
- [✅] Commit command: Created for template usage
- [⚠️] Other templates: Need Article V integration check

---

*This checklist ensures the constitution's principles are consistently applied across all project documentation.*