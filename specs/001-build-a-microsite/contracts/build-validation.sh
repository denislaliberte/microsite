#!/bin/bash
# Simple contract validation for Quartz build process

echo "🧪 Testing Quartz build contracts..."

# Test 1: Published markdown generates HTML
echo "Test 1: Published note generates HTML"
mkdir -p content/test
cat > content/test/published-note.md << 'EOF'
---
title: "Published Test"
publish: true
---
# Published Note
This should appear in the site.
EOF

npx quartz build
if [ -f "public/test/published-note/index.html" ]; then
    echo "✅ Published note generated HTML"
else
    echo "❌ Published note missing HTML"
    exit 1
fi

# Test 2: Unpublished markdown excluded
echo "Test 2: Unpublished note excluded"
cat > content/test/private-note.md << 'EOF'
---
publish: false
---
# Private Note
This should NOT appear.
EOF

npx quartz build
if [ ! -f "public/test/private-note/index.html" ]; then
    echo "✅ Unpublished note correctly excluded"
else
    echo "❌ Unpublished note incorrectly included"
    exit 1
fi

# Test 3: Wiki links between TIL notes work correctly  
echo "Test 3: Wiki links generate HTML links"
npx quartz build

# Check spec-kit note links to quartz note
if grep -q "href.*quartz-static-sites" "public/resources/til/2025-09-12-spec-kit/index.html"; then
    echo "✅ Spec Kit → Quartz link converted correctly"
else
    echo "❌ Spec Kit → Quartz link failed"
    exit 1
fi

# Check quartz note links back to spec-kit note  
if grep -q "href.*spec-kit" "public/resources/til/2025-09-12-quartz-static-sites/index.html"; then
    echo "✅ Quartz → Spec Kit link converted correctly"
else
    echo "❌ Quartz → Spec Kit link failed" 
    exit 1
fi

# Test 4: Unpublished TIL note is excluded
echo "Test 4: Private workflow note excluded"
if [ ! -f "public/resources/til/2025-09-12-quartz-publishing-workflow/index.html" ]; then
    echo "✅ Private workflow note correctly excluded"
else
    echo "❌ Private workflow note incorrectly published"
    exit 1
fi

echo "🎉 All contract tests passed!"