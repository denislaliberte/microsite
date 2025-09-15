# Domain Migration Plan: microsite → denislaliberte.github.io

## Overview

**Current State**: Obsidian microsite deployed at `denislaliberte.github.io/microsite`  
**Target State**: Microsite as the primary site at `denislaliberte.github.io`  
**Migration Type**: Repository replacement with backup retention

## Strategic Context

### Why Migrate?
- **Professional Presence**: Main domain provides cleaner, more authoritative web presence
- **SEO Benefits**: Primary domain has better search engine optimization potential
- **User Experience**: Shorter, more memorable URL for sharing and bookmarking
- **GitHub Pages Optimization**: Main repository receives priority treatment and features

### Business Impact
- **Positive**: Better branding, improved discoverability, professional appearance
- **Risk**: Temporary URL changes, potential external link breakage
- **Mitigation**: Comprehensive backup strategy and validation process

## Migration Strategy

### Approach: Complete Repository Replacement
Rather than attempting to preserve git history or merge repositories, we'll:

1. **Backup**: Create complete backup of existing `denislaliberte.github.io` content
2. **Replace**: Clear main repository and copy microsite content
3. **Reconfigure**: Update all configurations for main domain
4. **Validate**: Ensure complete functionality at new domain

### Success Criteria
- [ ] Zero data loss (complete backup maintained)
- [ ] All microsite functionality preserved
- [ ] Site accessible at `https://denislaliberte.github.io/`
- [ ] Performance and features match current microsite
- [ ] Professional test suite operational
- [ ] Documentation reflects new domain

## Risk Assessment

### High-Impact Risks
| Risk | Probability | Impact | Mitigation |
|------|-------------|---------|------------|
| Data loss during migration | Low | Critical | Complete backup + validation |
| Build failures on new domain | Medium | High | Thorough testing before deployment |
| External link breakage | High | Medium | Document old URLs, consider redirects |
| SEO ranking reset | Medium | Medium | Site will rebuild authority over time |

### Rollback Strategy
- **Immediate**: Branch-based rollback via git reset
- **Complete**: Restore from timestamped backup archive
- **Verification**: Backup testing before migration execution

## Prerequisites

### Technical Requirements
- [ ] Phase 5 tasks T025-T032 completed (professional test suite, validation)
- [ ] Current microsite fully functional and tested
- [ ] All content and configurations verified
- [ ] Backup storage space available (~500MB estimated)

### Access Requirements  
- [ ] Write access to `denislaliberte/denislaliberte.github.io` repository
- [ ] GitHub Pages permissions for main repository
- [ ] Local development environment operational

## Migration Phases

### Phase A: Preparation & Backup
**Duration**: 15-20 minutes  
**Focus**: Safety and data preservation

- Create timestamped backup of existing main repository
- Verify backup integrity and accessibility  
- Document current state and configurations
- Prepare migration workspace

### Phase B: Content Migration
**Duration**: 20-30 minutes  
**Focus**: Content transfer and configuration

- Clone main repository for migration
- Clear existing content (post-backup)
- Transfer all microsite files and configurations
- Update domain references in all files

### Phase C: Testing & Validation
**Duration**: 15-25 minutes  
**Focus**: Functionality verification

- Test build process with new domain configuration
- Run professional test suite
- Verify all core functionality (wiki links, search, mobile)
- Validate GitHub Actions workflow

### Phase D: Deployment & Monitoring
**Duration**: 10-15 minutes  
**Focus**: Go-live and verification

- Commit migration changes
- Deploy to production
- Monitor initial deployment
- Verify site accessibility and functionality

## Post-Migration Tasks

### Immediate (Day 1)
- [ ] Verify site accessibility at new domain
- [ ] Test all major functionality end-to-end
- [ ] Update personal bookmarks and references
- [ ] Monitor for any deployment issues

### Short-term (Week 1)
- [ ] Update any external services pointing to old URL
- [ ] Document migration in project notes
- [ ] Consider redirect strategy for old microsite URL
- [ ] Monitor site performance and user experience

### Long-term (Month 1)
- [ ] Review SEO performance at new domain
- [ ] Clean up any remaining references to old URL
- [ ] Evaluate migration success against objectives
- [ ] Archive backup files if migration successful

## Technical Considerations

### Domain Configuration
- Main repository automatically serves at `denislaliberte.github.io`
- No custom domain configuration required
- HTTPS automatically enabled by GitHub Pages
- CDN and caching handled by GitHub infrastructure

### Content Preservation
- All markdown content preserved via symlink to `~/notes/3-Ressources/`
- Quartz configuration and customizations maintained
- Test suite and CI/CD pipeline migrated
- Build performance and optimizations retained

### URL Structure Changes
```
OLD: https://denislaliberte.github.io/microsite/
NEW: https://denislaliberte.github.io/

OLD: https://denislaliberte.github.io/microsite/til/spec-kit/
NEW: https://denislaliberte.github.io/til/spec-kit/
```

## Decision Log

### Framework Selection
- **Chosen**: Complete repository replacement
- **Alternative**: Git subtree/submodule merge
- **Rationale**: Cleaner result, simpler maintenance, better performance

### Backup Strategy
- **Chosen**: Full repository clone + archive
- **Alternative**: Selective file backup
- **Rationale**: Complete safety, easy restoration, includes git history

### Testing Approach
- **Chosen**: Professional test suite validation
- **Alternative**: Manual testing only
- **Rationale**: Automated validation, consistent results, faster execution

## Communication Plan

### Internal Documentation
- Update project README with new URLs
- Update all spec files and documentation
- Update development environment configurations

### External Updates
- Personal notes and bookmarks
- Any shared links or references
- Social media profiles if applicable

---

## Implementation Reference

For detailed implementation steps, see: `specs/001-build-a-microsite/phases/phase-5-polish.md` (Task T033)

The implementation includes:
- Step-by-step bash scripts for each migration phase
- Validation checkpoints and testing procedures  
- Rollback procedures and safety measures
- Comprehensive checklists for verification

---

*This migration plan provides strategic guidance for moving the Obsidian microsite from a subdirectory to the main GitHub Pages domain, ensuring a safe, thorough, and successful transition.*