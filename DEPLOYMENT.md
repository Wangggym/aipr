# 部署与自动化流程（CI/CD）

本项目已集成 GitHub Actions，实现自动化发布和文档部署。

---

## 1. 自动发布到 crates.io

- 在本地打 tag 并推送：
  ```sh
  git tag v0.1.0
  git push origin v0.1.0
  ```
- GitHub Actions 会自动运行测试、构建，并将新版本发布到 [crates.io](https://crates.io/crates/aipr)。
- 需要在仓库 Settings → Secrets → Actions 添加 `CARGO_REGISTRY_TOKEN`，值为 crates.io 的 API Token。

## 2. 自动部署文档到 GitHub Pages

- 每次打 tag 发布时，GitHub Actions 会自动用 `cargo doc` 生成文档，并部署到 `gh-pages` 分支。
- 你只需在仓库 Settings → Pages 选择 `gh-pages` 分支和 `/ (root)` 目录。
- 文档地址一般为：
  https://wangggym.github.io/aipr/

## 3. CI 检查内容

- 自动检查：
  - 代码能否编译
  - 测试是否通过
  - 代码格式（cargo fmt）
  - 静态分析（cargo clippy）

## 4. 本地手动发布与版本号管理（可选）

- 发布到 crates.io：
  ```sh
  cargo publish
  ```
- 生成本地文档：
  ```sh
  cargo doc --no-deps --open
  ```
- 使用 Makefile 自动递增版本号：
  - 递增 patch 版本号：
    ```sh
    make bump-patch
    ```
  - 递增 minor 版本号：
    ```sh
    make bump-minor
    ```
  - 递增 major 版本号：
    ```sh
    make bump-major
    ```
  - 一键递增 patch 并发布（自动 commit、tag、push）：
    ```sh
    make release-patch
    ```

---

如需修改自动化流程，请编辑 `.github/workflows/ci-cd.yml`。 