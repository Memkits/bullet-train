import { appendFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

export function selectCdnPath({ origin, repository, eventName, ref, refName, prNumber }) {
  if (!origin || !repository) throw new Error("CDN origin and repository are required");

  let suffix;
  if (eventName === "pull_request") {
    if (!/^[1-9]\d*$/.test(String(prNumber ?? ""))) throw new Error("A PR number is required for pull requests");
    suffix = `pr/${prNumber}/`;
  } else if (eventName === "push" && ref === "refs/heads/main") {
    suffix = "";
  } else {
    if (!refName) throw new Error("A ref name is required for branch builds");
    suffix = `branches/${refName}/`;
  }

  const prefix = `${repository}/${suffix}`;
  return { prefix, baseUrl: `${origin.replace(/\/$/, "")}/${prefix}` };
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const { prefix, baseUrl } = selectCdnPath({
    origin: process.env.CDN_ORIGIN,
    repository: process.env.GITHUB_REPOSITORY,
    eventName: process.env.GITHUB_EVENT_NAME,
    ref: process.env.GITHUB_REF,
    refName: process.env.GITHUB_REF_NAME,
    prNumber: process.env.PR_NUMBER,
  });
  appendFileSync(process.env.GITHUB_ENV, `VITE_BASE_URL=${baseUrl}\n`);
  appendFileSync(process.env.GITHUB_OUTPUT, `prefix=${prefix}\nbase-url=${baseUrl}\n`);
}
