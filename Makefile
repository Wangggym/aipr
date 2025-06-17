# Makefile for Rust crate version management and release (macOS version)

# 递增 patch 版本号
detect-version = $(shell grep '^version =' Cargo.toml | head -1 | cut -d'"' -f2)

bump-patch:
	@echo "Current version: $(call detect-version)"
	@ver=$(call detect-version); \
	major=$${ver%%.*}; \
	minor_patch=$${ver#*.}; \
	minor=$${minor_patch%%.*}; \
	patch=$${minor_patch#*.}; \
	patch=$$(($$patch + 1)); \
	new_ver="$$major.$$minor.$$patch"; \
	sed -i '' -E "s/^version = \".*\"/version = \"$$new_ver\"/" Cargo.toml; \
	echo "Bumped to version: $$new_ver"

# 递增 minor 版本号
bump-minor:
	@ver=$(call detect-version); \
	major=$${ver%%.*}; \
	minor_patch=$${ver#*.}; \
	minor=$${minor_patch%%.*}; \
	minor=$$(($$minor + 1)); \
	new_ver="$$major.$$minor.0"; \
	sed -i '' -E "s/^version = \".*\"/version = \"$$new_ver\"/" Cargo.toml; \
	echo "Bumped to version: $$new_ver"

# 递增 major 版本号
bump-major:
	@ver=$(call detect-version); \
	major=$${ver%%.*}; \
	major=$$(($$major + 1)); \
	new_ver="$$major.0.0"; \
	sed -i '' -E "s/^version = \".*\"/version = \"$$new_ver\"/" Cargo.toml; \
	echo "Bumped to version: $$new_ver"

# 一键发布（递增 patch + commit + tag + push）
release-patch: bump-patch
	@git add Cargo.toml
	@git commit -m "Bump version"
	@ver=$(call detect-version); \
	git tag v$$ver
	@git push origin master --tags

# 你可以类似添加 release-minor、release-major 