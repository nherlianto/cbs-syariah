#!/usr/bin/env node
// PostToolUse formatter: runs the frontend's own Prettier on files Claude
// edits under frontend/. Other files (Java, SQL, Gradle) are left alone.
// Never fails the tool call; formatting problems are reported, not fatal.
const { execFileSync } = require("node:child_process");
const fs = require("node:fs");
const path = require("node:path");

const projectDir = process.env.CLAUDE_PROJECT_DIR || process.cwd();
const frontendDir = path.join(projectDir, "frontend");
const prettier = path.join(frontendDir, "node_modules", ".bin", "prettier");
const formattable = /\.(ts|tsx|js|jsx|mjs|cjs|json|css|scss|html|md)$/;

let input = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (c) => (input += c));
process.stdin.on("end", () => {
  let filePath;
  try {
    filePath = JSON.parse(input).tool_input?.file_path;
  } catch {
    process.exit(0);
  }
  if (!filePath) process.exit(0);

  const abs = path.resolve(projectDir, filePath);
  const rel = path.relative(frontendDir, abs);
  if (rel.startsWith("..") || path.isAbsolute(rel)) process.exit(0);
  if (rel.split(path.sep).includes("node_modules")) process.exit(0);
  if (!formattable.test(abs) || !fs.existsSync(abs)) process.exit(0);
  if (!fs.existsSync(prettier)) process.exit(0); // not installed: skip quietly

  try {
    execFileSync(prettier, ["--write", "--log-level", "warn", abs], {
      cwd: frontendDir,
      stdio: ["ignore", "ignore", "pipe"],
    });
  } catch (e) {
    process.stderr.write(`prettier failed on ${rel}: ${e.stderr || e.message}\n`);
  }
  process.exit(0);
});
