#!/usr/bin/env node
// PreToolUse guard for Edit/Write/MultiEdit/Bash.
// Exit 2 blocks the tool call and shows stderr to Claude; exit 0 allows it.
const { execFileSync } = require("node:child_process");
const path = require("node:path");

const projectDir = process.env.CLAUDE_PROJECT_DIR || process.cwd();

function block(reason) {
  process.stderr.write(`Blocked by .claude/hooks/protect.sh: ${reason}\n`);
  process.exit(2);
}

function isTracked(rel) {
  try {
    execFileSync("git", ["ls-files", "--error-unmatch", "--", rel], {
      cwd: projectDir,
      stdio: "ignore",
    });
    return true;
  } catch {
    return false;
  }
}

function checkFile(filePath) {
  if (!filePath) return;
  const rel = path
    .relative(projectDir, path.resolve(projectDir, filePath))
    .split(path.sep)
    .join("/");
  const base = path.posix.basename(rel);

  if (/^\.env(\..+)?$/.test(base) && base !== ".env.example") {
    block(`${rel} holds secrets; edit it by hand.`);
  }
  if (base === "package-lock.json") {
    block("package-lock.json is generated; change package.json and run npm install.");
  }
  // Flyway checksums committed migrations; changing one breaks every database
  // it was applied to. Add a new V<n>__*.sql migration instead.
  if (/(^|\/)db\/migration\/[^/]+\.sql$/.test(rel) && isTracked(rel)) {
    block(`${rel} is a committed Flyway migration; add a new migration instead.`);
  }
}

function checkCommand(cmd) {
  if (!cmd) return;
  if (/\bgit\s+push\b[^;&|]*(\s--force(-with-lease)?\b|\s-[a-zA-Z]*f\b)/.test(cmd)) {
    block("force push is not allowed.");
  }
  if (/\bgit\s+push\b[^;&|]*\s(origin\s+)?(HEAD:)?main\b/.test(cmd)) {
    block("push to main directly is not allowed; push a branch and open a PR.");
  }
  if (/\brm\s+-[a-zA-Z]*[rR][a-zA-Z]*\s+(-[a-zA-Z]+\s+)*(\/|~|\$HOME|\.|\*)(\s|$)/.test(cmd)) {
    block("recursive delete of /, ~, . or * is not allowed.");
  }
  if (/(^|[\s;&|])(cat|less|more|head|tail|bat|cp|scp|curl)\b[^;&|]*(^|[\s/])\.env(\s|$)/.test(cmd)) {
    block(".env holds secrets and must not be read.");
  }
  if (/\bdocker\s+compose\b[^;&|]*\bdown\b[^;&|]*\s(-v|--volumes)\b/.test(cmd)) {
    block("docker compose down -v wipes the Postgres and Keycloak volumes; run it yourself if intended.");
  }
}

let input = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (c) => (input += c));
process.stdin.on("end", () => {
  let event;
  try {
    event = JSON.parse(input);
  } catch {
    process.exit(0); // malformed input: don't wedge the session
  }
  const tool = event.tool_name;
  const ti = event.tool_input || {};
  if (tool === "Bash") checkCommand(ti.command);
  else checkFile(ti.file_path);
  process.exit(0);
});
