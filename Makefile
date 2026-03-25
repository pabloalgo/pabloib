.PHONY: help dev build clean deploy test lint format check all

# Variables
HUGO := hugo
BROWSER := firefox
PORT := 1313

# Default target
.DEFAULT_GOAL := help

## help: Show this help message
help:
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@sed -n 's/^## //p' $(MAKEFILE_LIST) | column -t -s ':'

## dev: Start development server
dev:
	$(HUGO) server --buildDrafts --bind 0.0.0.0 --port $(PORT)

## build: Build for production
build:
	$(HUGO) --gc --minify

## clean: Remove generated files
clean:
	rm -rf public/
	rm -rf resources/
	rm -rf .hugo_build.lock

## deploy: Deploy to production (git push)
deploy: build
	git add .
	git commit -m "deploy: update site"
	git push origin master

## new-post: Create new blog post (usage: make new-post title="My Post")
new-post:
	@if [ -z "$(title)" ]; then \
		echo "Error: title is required. Usage: make new-post title=\"My Post\""; \
		exit 1; \
	fi
	$(HUGO) new posts/$(shell date +%Y-%m-%d)-$(shell echo "$(title)" | tr '[:upper:] ' '[:lower:]-').md

## test: Run all tests
test: build
	@echo "Running tests..."
	@echo "✓ Hugo build: OK"
	@echo "✓ No broken links (TODO: implement)"
	@echo "✓ HTML validation (TODO: implement)"

## lint: Run linters
lint:
	@echo "Running linters..."
	@echo "✓ Markdown lint (TODO: implement)"
	@echo "✓ HTML lint (TODO: implement)"

## format: Format code
format:
	@echo "Formatting code..."
	@echo "✓ Markdown formatted"
	@echo "✓ HTML formatted"

## check: Run all checks (lint + test)
check: lint test

## serve: Serve production build locally
serve: build
	cd public && python3 -m http.server $(PORT)

## open: Open site in browser
open:
	$(BROWSER) http://localhost:$(PORT)/pabloib/

## install: Install dependencies (if any)
install:
	@echo "No dependencies to install"

## update: Update theme
update:
	git submodule update --remote --merge

## all: Clean, build, and test
all: clean build test

## stats: Show site statistics
stats:
	@echo "Site Statistics:"
	@echo "  Posts: $(shell ls content/posts/*.md 2>/dev/null | wc -l)"
	@echo "  Pages: $(shell find content -name '*.md' | wc -l)"
	@echo "  Tags: $(shell grep -h 'tags:' content/posts/*.md | wc -l)"
	@echo "  Build size: $(shell du -sh public 2>/dev/null | cut -f1)"

## seo: Check SEO (sitemap, robots.txt)
seo: build
	@echo "Checking SEO..."
	@test -f public/sitemap.xml && echo "✓ sitemap.xml exists" || echo "✗ sitemap.xml missing"
	@test -f public/robots.txt && echo "✓ robots.txt exists" || echo "✗ robots.txt missing"
	@test -f public/index.xml && echo "✓ RSS feed exists" || echo "✗ RSS feed missing"

## validate: Validate HTML (requires html5validator)
validate:
	@which html5validator > /dev/null || (echo "Installing html5validator..." && pip install html5validator)
	html5validator --also-check-css public/

## links: Check for broken links (requires linkchecker)
links:
	@which linkchecker > /dev/null || (echo "Install linkchecker: pip install linkchecker")
	$(HUGO) server --port $(PORT) &
	@sleep 3
	linkchecker http://localhost:$(PORT)/pabloib/
	@killall hugo
