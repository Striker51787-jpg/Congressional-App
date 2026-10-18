# Wake Drive: agent instructions

Read by both Codex (AGENTS.md) and Claude Code (via CLAUDE.md, which imports this file).

## What this is
Wake Drive is a mobile-first web app for the Congressional App Challenge 2026.
It checks a driver's route against live creek gauges (USGS) and weather alerts
(NWS) for flood-prone crossings in Wake County, NC, and suggests an alternate
route when a crossing is red. The full spec is in docs/SPEC.md. Read it before
starting any task, and follow its section numbers when asked.

## Stack
TypeScript (strict) everywhere. Next.js App Router with route handlers for the
backend, Tailwind CSS, Leaflet via react-leaflet, Turf.js for geometry, SWR for
client fetching, Zod for validation, Vitest for tests, lucide-react for icons.
No database. No user accounts.

## Commands
- npm run dev: start the dev server
- npm test: run unit tests (must pass before every commit)
- npm run lint and npm run build: must pass before merging
- npm run find-gauges: list USGS gauges in Wake County

## Hard rules (never break these)
1. Never invent crossing coordinates, USGS site IDs, NWS gauge IDs or flood
   thresholds. If unknown, use null, set verified to false, and tell the
   students what is missing. Unverified crossings render as unknown.
2. The risk engine must never return green when data is missing, stale (older
   than 120 minutes), or when the alert fetch failed. Return unknown instead.
   Unknown is never treated as safe.
3. Never describe a crossing as safe. Green means "no flood signals". Keep the
   safety disclaimer on every screen.
4. Coordinate order: Leaflet uses [lat, lng]. GeoJSON, Turf and OpenRouteService
   use [lng, lat]. Convert only through src/lib/geo.ts.
5. Secrets (ORS_API_KEY) are server-side only. Never commit .env.local. Never
   use a NEXT_PUBLIC_ prefix for secrets. The browser never calls USGS, NWS or
   OpenRouteService directly.
6. Demo mode changes the engine's inputs, never its outputs. Everything shown in
   demo mode is marked simulated.
7. Status is always icon plus color plus text label.
8. Every upstream call has an 8 second timeout and fails soft: the endpoint
   returns 200 with the feed marked not ok, and affected crossings become
   unknown.

## Who owns what (avoids merge conflicts)
- Partner A (frontend): src/components/ and page files under src/app/
  (excluding src/app/api/).
- Partner B (data and logic): src/lib/, src/app/api/, data/ and scripts/.
- src/lib/types.ts is shared. Change it only in its own small PR that both
  partners approve.
- Work only inside your own partner's folders. If a task needs a change in the
  other partner's folder, stop and say so instead of editing it.

## Student authorship (competition rules require it)
The students write the risk engine rules (src/lib/engine), the crossing dataset
(data/crossings.json) and the demo scenarios. For those files, propose changes,
review the students' code, and write tests from the spec, but do not silently
rewrite their logic. Everything else you may draft, and the students review it.

## Working agreements
- Work in small steps on a feature branch, never directly on main.
- After each step run npm test and npm run lint, then summarize what changed in
  plain language so both students can explain it.
- Ask before adding any new dependency.
- Add or update an entry in docs/AI_LOG.md at the end of each session: what you
  produced, and what the students must verify.
- Write unit tests for pure logic first. Use saved fixtures in tests/fixtures,
  never live network calls in tests.
- Prefer clear, readable code over clever code. Students will present it.
- If the spec and the code disagree, stop and ask which one is right.
