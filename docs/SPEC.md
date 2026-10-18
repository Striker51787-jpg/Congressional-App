Wake Drive - Full Build Spec for Claude Code




  Wake Drive - Full Build Spec for Claude Code
     Oct 18, 2026         · ​@Ahan


  1. Overview
  Wake Drive is a free, phone-friendly web app that tells a Wake County driver, before they
  leave, whether their route crosses a creek or low spot that is flooding right now, and what
  route to take instead.

  The problem. Crabtree Creek and Walnut Creek flood roads quickly in heavy rain. Raleigh
  runs stream gauges and flashing flood-warning signs at roughly 10 crossings, and USGS
  and the National Weather Service publish live data. But nothing combines those feeds
  with a driver's own commute and warns them in advance. New teen drivers are the most
  exposed.

  Who it serves. Every driver in the Triangle: teens with provisional licenses, NC State,
  Wake Tech and Meredith commuters, and parents doing school runs. This is a broad
  audience, which matters for the "impact" part of judging.

  The pitch (use this in the video). "Wake Drive checks your route against live creek gauges
  and weather alerts, and reroutes you around flooded crossings before you leave the
  driveway."

  What makes it competitive. It uses real, live public data (not mock data), does visible
  engineering work (spatial route analysis, a risk engine, alternate routing), has a
  documented local need, and can be demoed end to end by two people in under three
  minutes with a built-in simulated-flood mode.

  Hard dates.

        Target submission: Sunday, Oct 25, 2026.
        Official deadline: Monday, Oct 26, 2026 at 12:00 PM ET. Rep. Knott's NC-13 page says
        8:00 PM, but the national rules say noon. Use noon.
        Submissions cannot be edited after the deadline.

  How Claude Code should use this doc. Read sections 3 through 11 to build, section 15 for
  the project instructions and first prompts, and section 13 for the safety rules that must
  not be skipped.




                                                                                            Page 1 of 33
Wake Drive - Full Build Spec for Claude Code




  2. Competition constraints
  The 2026 Congressional App Challenge rules shape what the build must contain, so each
  rule below maps to a concrete requirement for Wake Drive.


     Rule                                             What it means for the build

     Middle or high school students only; teams       Both partners must be students. Register
     of up to 4; one entry per person                 once, as a team.

     Enter in the district where you live or attend   Check both home and school addresses
     school                                           against the district lookup before
                                                      registering. Wake County is split among NC-
                                                      2, NC-4 and NC-13.

     App must be created after Oct 30, 2025           Start a fresh git repo. Commit history
                                                      documents the start date.

     App must show some degree of                     The live-data flow must work for real, not as
     functionality                                    a mockup.

     Judges may request source code or a              Keep the repo clean and runnable from the
     working app                                      README, and deploy a public URL.

     AI use is allowed but must be fully disclosed,   Keep the AI-use log in section 13. Each
     and cannot be the entirety of technical          partner must be able to explain every
     development                                      module.

     Open-source libraries must be documented         Maintain a CREDITS section in the README
                                                      listing every library and data source.

     1 to 3 minute public YouTube or Vimeo demo       Script in section 14. Must state names, app
     video                                            name, purpose, audience, tools and show a
                                                      live demo.

     Written answers: inspiration, hardest            Draft notes in section 14.
     technical problem, what you learned, a 2.0
     version

     Registration needs a personal email, home        Gather these on Sunday so nothing blocks
     and school 9-digit ZIPs, parent or guardian      submission.
     contact




                                                                                                Page 2 of 33
Wake Drive - Full Build Spec for Claude Code




  Judging criteria (official). Quality of the idea (creativity and originality), implementation
  (user experience and design), and demonstrated excellence of coding and programming
  skills. The spatial analysis, risk engine and live-data integration are the "coding excellence"
  evidence. The map UI and clear status design are the "implementation" evidence.

  Submission is final. Nothing can be changed after the deadline, so submit on Oct 25.


  3. Product scope
  The MVP is one complete flow: pick a start and end point, see which flood-prone
  crossings the route passes, see each crossing's live status, and get a safer alternate route
  if any crossing is red. Everything else is optional.

  In scope (MVP)

        Live map of known flood-prone crossings, each colored and labeled green, yellow, red
        or unknown.
        Route check: enter or tap a start and end, get the driving route, and list the crossings
        on it with their status and the reason.
        Alternate route that avoids red crossings, with the added distance and time shown.
        Crossing detail view: current gauge stage and flow, a short recent trend, the
        thresholds used and their source, active alerts, and time of last update.
        Saved routes stored in the browser (localStorage), with a one-tap re-check.
        Demo mode: a clearly labeled simulated high-water scenario.
        Safety and About page: disclaimer, data sources, credits and AI disclosure.

  Out of scope (do not build unless everything above is done and tested)

        User accounts, login or a server-side database.
        Push notifications, SMS or email alerts.
        Parent dashboards or sharing.
        Native iOS or Android apps. The PWA is enough.
        Crowdsourced reports, historical analytics or predictions.
        Coverage outside Wake County and offline use.

  End-to-end user flow

    1. User opens the site and sees the map with every crossing colored by current status,
       plus a banner showing data freshness and any active flood alerts.




                                                                                             Page 3 of 33
Wake Drive - Full Build Spec for Claude Code




    2. User taps "Check my route" and sets a start and end by typing an address, tapping the
       map, or using their location.
    3. The app requests a driving route, finds crossings within a short distance of the route
        line, and evaluates each one.
    4. The result card shows an overall status (the worst crossing on the route) and a list of
        crossings with status, reason and last-updated time.
    5. If any crossing is red, the app requests an alternate route that avoids it and shows it
        next to the original with the extra distance and time. If no safe alternate exists, it says
        so and advises delaying the trip.
    6. User can save the route, open any crossing for detail, or toggle Demo mode to see a
        simulated flood.

  MVP is done when: a route from Cary to NC State returns correct crossings and statuses
  from live data, an alternate route is produced in Demo mode, and the whole flow works on
  a phone browser.


  4. Architecture and tech stack
  Wake Drive is one Next.js app written entirely in TypeScript. The browser never calls the
  live data feeds itself. Our server fetches them, runs the risk engine and returns plain
  JSON, and it holds the only secret key.


     Layer                    Choice                            Why

     Language                 TypeScript, strict mode           One language for both partners and
                                                                Claude Code, with shared types
                                                                between frontend and backend

     Framework                Next.js (App Router)              Pages and API routes in one repo,
                                                                free deployment on Vercel

     Styling                  Tailwind CSS                      Fast, mobile-first layouts

     Map                      Leaflet and react-leaflet with    Free and needs no key
                              OpenStreetMap tiles

     Geometry                 Turf.js                           Point-to-line distance, circles,
                                                                bounding boxes

     Routing                  OpenRouteService, with the OSRM   Free tier, supports avoid-polygons
                              demo server as fallback



                                                                                                   Page 4 of 33
Wake Drive - Full Build Spec for Claude Code




     Layer                    Choice                                Why

     Client data              SWR                                   Polling and revalidate-on-focus with
                                                                    little code

     Validation               Zod                                   Safe parsing of requests and
                                                                    upstream responses

     Tests                    Vitest                                Fast unit tests for the engine and
                                                                    geometry

     Storage                  None on the server. localStorage in   No accounts means no database
                              the browser                           and less privacy risk




  system architecture · 3 layers, 4 external services

  The browser calls only our API routes. The API routes combine the crossing data, the risk
  engine and the routing logic, and call USGS, NWS and OpenRouteService. Only the map
  tiles come straight from OpenStreetMap to the browser.

  How a request flows




                                                                                                     Page 5 of 33
Wake Drive - Full Build Spec for Claude Code




    1. Page load. The browser calls GET /api/crossings . The server reads crossings.json ,
        makes one USGS call for all gauges and one NWS alert lookup, runs evaluateCrossing
        for every crossing and returns the statuses.
    2. Route check. The browser posts a start and an end. The server gets a route from
        OpenRouteService, finds the crossings along it with Turf, evaluates them, and asks for
        an alternate route only if one is red.
    3. Demo mode. The server swaps the engine's inputs for simulated ones before
        evaluating, so the real logic still runs.
    4. Caching. A small in-memory cache sits between the server and each feed, so many
        users do not multiply upstream calls.
    5. Failure. If any feed fails, the endpoint still answers with 200 and marks the affected
       crossings unknown.


  5. Data sources
  Wake Drive needs five external feeds plus one hand-built dataset. All feeds are free; only
  OpenRouteService needs a key. Verify each endpoint returns data on day one, because
  public APIs change.


     Source                            Used for      Endpoint                                      Auth

     USGS Water                        Live gauge    https://waterservices.usgs.gov/nwis/iv/?      None
     Services,                         height (ft)   format=json&sites=
     instantaneous                     and           <ids>&parameterCd=00065,00060&period=PT3H&s
     values                            discharge     iteStatus=all
                                       (cfs) at
                                       stream
                                       gauges

     USGS site service                 One-time      https://waterservices.usgs.gov/nwis/site/?    None
                                       lookup of     format=rdb&stateCd=NC&countyCd=37183&siteTy
                                       gauge IDs     pe=ST&hasDataTypeCd=iv
                                       in Wake
                                       County

     NWS alerts API                    Active        https://api.weather.gov/alerts/active?        None, but a
                                       flood and     point=<lat>,<lon>                             descriptive
                                       flash flood                                                 User-Agent
                                       watches                                                     header with
                                       and                                                         contact info is
                                       warnings                                                    required
                                       at a point




                                                                                                               Page 6 of 33
Wake Drive - Full Build Spec for Claude Code




     Source                            Used for      Endpoint                                      Auth

     NWS NWPS gauge                    Official      https://api.water.noaa.gov/nwps/v1/gauges/<   None
     API                               flood-        LID>
                                       stage
                                       categories
                                       (action,
                                       minor,
                                       moderate,
                                       major)
                                       where a
                                       crossing's
                                       gauge is an
                                       NWS
                                       forecast
                                       point

     OpenRouteService                  Driving       POST                                          API key in the
     directions                        route and     https://api.openrouteservice.org/v2/directi   Authorization
                                       alternate     ons/driving-car/geojson                       header
                                       routes that
                                       avoid
                                       polygons

     OpenRouteService                  Address       GET                                           API key as
     geocoding                         search,       https://api.openrouteservice.org/geocode/se   api_key query
                                       limited to    arch                                          parameter
                                       the Raleigh
                                       area

     OpenStreetMap                     Base map      https://tile.openstreetmap.org/{z}/{x}/{y}.   None;
     tiles via Leaflet                               png                                           attribution
                                                                                                   required, low
                                                                                                   volume only


  USGS response shape. The JSON holds value.timeSeries[] . Each series has
  sourceInfo.siteCode[0].value (the site ID), variable.variableCode[0].value
  ( 00065 is gauge height in feet, 00060 is discharge in cfs), and values[0].value[] as {
  value: "3.45", dateTime: "2026-10-18T10:15:00.000-04:00" } . Values arrive as
  strings, and a missing reading can appear as -999999 . Treat that as no data.

  NWS alert response shape. A GeoJSON FeatureCollection. Read
  features[].properties.event , severity , headline , effective , expires and
   areaDesc . Always send the User-Agent header, for example WakeDrive (contact: <team
  email>) .




                                                                                                               Page 7 of 33
Wake Drive - Full Build Spec for Claude Code




  Endpoint risks to check first. USGS has been moving water data to newer APIs, so
  confirm the iv endpoint still responds. If it does not, find the replacement in USGS
  documentation and keep the same internal interface. Confirm the NWPS response field
  names by calling one gauge by hand before writing the parser. Check the
  OpenRouteService free-tier limits in your dashboard and cache aggressively.

  Routing fallback. If OpenRouteService fails, use the public OSRM demo server for plain
  routes with alternatives=true : https://router.project-
  osrm.org/route/v1/driving/<lng>,<lat>;<lng>,<lat>?
  overview=full&geometries=geojson&alternatives=true . It does not support avoid-
  polygons, so alternates become best-effort. Do not rely on it for the final demo.


  Crossing dataset (hand-built)
  The list of flood-prone crossings is the app's core data, and no API provides it. Build it by
  hand in data/crossings.json from the City of Raleigh flood-warning-sign page (about 10
  sites) plus any crossings the team knows flood. Each entry follows this type:

     type Crossing = {
       id: string;                             // slug, e.g. "crabtree-creek-lassiter-mill"
         name: string;                         // display name
         road: string;
         creek: string;
         lat: number | null;                   // set by hand from a map; never guessed
         lng: number | null;
         gaugeSiteId: string | null; // USGS site number, if one is nearby and
     relevant
       nwsLid: string | null;                  // NWS gauge ID, if the gauge is an NWS
     forecast point
       thresholds: {
             actionFt: number | null;
             minorFt: number | null;
           source: "nws" | "team-heuristic" | "none";
         };
       matchRadiusM: number;                   // how close a route must pass to count,
     default 60
         sourceUrl: string;                    // page this crossing came from
         verified: boolean;                    // true only after a human checked coordinates
     and gauge
     };




                                                                                              Page 8 of 33
Wake Drive - Full Build Spec for Claude Code




  The four crossings named in the research are the seed list: Creedmoor Rd near Crabtree
  Valley Mall, Crabtree Creek at Lassiter Mill, Crabtree Creek at Anderson Dr, and Walnut
  Creek at Avent Ferry Rd. Add the remaining signs from the city page.

  Rule for Claude Code: never invent coordinates, gauge IDs or thresholds. Leave them
  null and set verified: false . The app shows unknown for any crossing without a
  verified location and gauge. The human partners fill these in, using scripts/find-
  gauges.ts (section 11) to list USGS gauges in Wake County.



  6. Flood risk engine
  The risk engine is a pure function that turns a crossing, its latest gauge reading and any
  active alerts into one of four levels: red, yellow, green or unknown. It must never show
  green when the data is missing or stale. This is the core of the project, so the partners
  write it by hand with AI review, and it has unit tests.

  Levels and labels


     Level                 Label shown         Meaning

     Red                   Avoid               A flood or flash flood warning covers the crossing,
                                               or the gauge is at or above its minor flood stage

     Yellow                Use caution         A watch or advisory covers the crossing, the gauge
                                               is at or above its action stage, or the water is rising
                                               fast

     Green                 No flood signals    Alerts were checked successfully, none apply, and
                                               any gauge here is fresh and below thresholds

     Unknown               Can't confirm       The crossing is unverified, or data is missing or
                                               stale. Never treated as safe


  Always show an icon and the text label as well as the color, so the status is readable
  without color vision.

  Inputs and output

     type Level = "red" | "yellow" | "green" | "unknown";


     type GaugeReading = {
       stageFt: number | null;




                                                                                                         Page 9 of 33
Wake Drive - Full Build Spec for Claude Code




          dischargeCfs: number | null;
          observedAt: string;          // ISO timestamp from USGS
          riseFtLastHour: number | null; // computed from the last ~3 hours of
     readings
     } | null;


     type Alert = {
          event: string;                       // e.g. "Flash Flood Warning"
          severity: string;
          headline: string;
          expires: string;
     };


     type EngineInput = {
       crossing: Crossing;
          reading: GaugeReading;
          alerts: Alert[] | null;              // null means the alert fetch failed
       now: string;                            // ISO timestamp, injected so tests are
     deterministic
     };


     type CrossingStatus = {
       crossingId: string;
          level: Level;
          reasons: string[];                   // plain-language reasons, shown in the UI
          stageFt: number | null;
          observedAt: string | null;
          thresholdSource: "nws" | "team-heuristic" | "none";
          simulated: boolean;          // true in demo mode
     };


     function evaluateCrossing(input: EngineInput): CrossingStatus;


  Rules, evaluated together. The worst result wins in the order red, yellow, unknown,
  green.

    1. Unverified crossing. If crossing.verified is false or its coordinates are null, return
        unknown with the reason "Location not yet verified."
    2. Alerts. An active Flash Flood Warning or Flood Warning makes the crossing red.
        An active Flash Flood Watch , Flood Watch or Flood Advisory makes it yellow.
        Ignore alerts whose expires time is in the past.




                                                                                            Page 10 of 33
Wake Drive - Full Build Spec for Claude Code




    3. Stage thresholds. When thresholds.source is nws or team-heuristic , a stage at or
        above minorFt is red and at or above actionFt is yellow. Label the source in the
        reason text, for example "Gauge at 9.4 ft, above NWS minor flood stage."
    4. Rapid rise. If riseFtLastHour is at or above the constant RISE_YELLOW_FT_PER_HOUR ,
        the crossing is yellow. Set that constant only after looking at real readings during a rain
        event, and document the value as a team heuristic, not an official figure.
    5. Stale or missing gauge. If the crossing has a gauge but the reading is missing, older
       than 120 minutes, or flagged as ice or equipment trouble, add the reason "Gauge data
       unavailable" and do not allow green from the gauge.
    6. Failed alert fetch. If alerts is null, add the reason "Alert service unavailable" and do
       not allow green.
    7. Green only when the alert fetch succeeded, no rule above fired, and either the
       crossing has no gauge or its gauge is fresh and below thresholds. A crossing with no
        gauge shows the reason "No active alerts. No gauge at this crossing."

  Route-level status is the worst crossing on the route, using the same order. A route with
  no crossings is green with the reason "No known flood-prone crossings on this route."

  Caching. USGS gauges update about every 15 minutes, so cache gauge responses for 5
  minutes. Cache NWS alerts for 3 minutes. Fetch each unique gauge once per refresh even
  when several crossings share it.

  Unit tests required (Vitest). Each case below needs its own test with a fixed now .

        No alerts, fresh reading below action stage: green.
        Flash Flood Warning at the point: red.
        Flood Watch only: yellow.
        Reading at the minor stage: red. At the action stage: yellow.
        Reading older than 120 minutes: unknown, never green.
        Alert fetch failed: unknown, never green.
        Expired alert is ignored.
        Unverified crossing: unknown.
        Rapid rise above the constant: yellow.
        Value -999999 from USGS is treated as missing.




                                                                                             Page 11 of 33
Wake Drive - Full Build Spec for Claude Code




  7. Routing and crossing detection
  The route check turns two points into a driving route, finds which known crossings that
  route passes, and, if any is red, asks the router for a path that avoids them. All geometry
  work uses Turf.js on the server.

  Coordinate order warning. Leaflet uses [lat, lng] . GeoJSON, Turf and
  OpenRouteService use [lng, lat] . Mixing these up is the most common bug in this kind
  of app. Define one helper module ( lib/geo.ts ) that converts between them, and never
  pass raw arrays between layers without it.

  Step 1: geocode. The search box calls our /api/geocode , which proxies the
  OpenRouteService geocoder with the focus point near Raleigh and a boundary box
  around Wake County (roughly lon -79.0 to -78.2, lat 35.5 to 36.1, approximate and
  deliberately generous). Users can also tap the map or use navigator.geolocation ,
  which only works over HTTPS.

  Step 2: base route. Call POST /v2/directions/driving-car/geojson with {
  "coordinates": [[lng, lat], [lng, lat]], "instructions": false } . Read the
  route from features[0].geometry (a LineString) and the totals from
   features[0].properties.summary ( distance in meters, duration in seconds).

  Step 3: find crossings on the route.

    1. Load verified crossings that have coordinates.
    2. Prefilter with the route's bounding box ( turf.bbox ) expanded by about 200 m so the
        distance check runs on few points.
    3. For each remaining crossing, compute turf.pointToLineDistance(point, route, {
       units: "meters" }) . Keep it if the distance is at most crossing.matchRadiusM
        (default 60).
    4. Sort the kept crossings by their position along the route using
         turf.nearestPointOnLine(route, point).properties.location .
    5. Evaluate each with the risk engine (section 6) and compute the route-level status.

  Crossings without verified coordinates cannot be matched to a route. They still appear on
  the map as unknown, and the result card lists them in a short note, for example "2
  crossings could not be checked."

  Step 4: alternate route, only if any matched crossing is red.




                                                                                         Page 12 of 33
Wake Drive - Full Build Spec for Claude Code




    1. For each red crossing, build a circle with turf.circle([lng, lat], radiusKm, {
        steps: 16 }) . Start with 0.12 km and tune after testing so it blocks the flooded road
        without closing a whole neighborhood.
    2. Combine the circles into one MultiPolygon .
    3. Call the same directions endpoint with "options": { "avoid_polygons":
       <MultiPolygon> } .
    4. Run the new route through step 3 and the risk engine. Accept it only if no crossing on it
       is red. A yellow crossing is allowed but flagged.
    5. Return both routes with extraDistanceM and extraDurationS computed from the
        summaries.
    6. If the router returns an error, no route, or only a route that still hits a red crossing,
       return alternate: null . The UI then says "No safe alternate found. Consider delaying
        your trip."

  If the start or end point sits inside an avoid circle, the router will fail. Handle that case with
  the same message.

  Saved routes. Store { id, name, start: { lat, lng, label }, end: { lat, lng,
  label } } in localStorage . Do not store route geometry. Recompute on every check,
  since conditions change.

  Performance. The route check should return in a few seconds. Fetch gauges and alerts in
  parallel with Promise.all , reuse the cached values from section 6, and limit alert lookups
  to the crossings that matched the route.


  8. Backend API spec
  The backend is five Next.js route handlers under app/api/ . They hold the
  OpenRouteService key, call the public feeds, run the risk engine and return plain JSON.
  The browser never calls USGS, NWS or OpenRouteService directly.


     Method and path                           Purpose                                   Cache

      GET /api/crossings                       All crossings with current status, plus   3 to 5 min, per feed
                                               the active alert summary and feed
                                               health

      GET                                      One crossing with its last 3 hours of     5 min
     /api/crossings/[id]                       gauge readings




                                                                                                           Page 13 of 33
Wake Drive - Full Build Spec for Claude Code




     Method and path                           Purpose                             Cache

      POST /api/route/check                    Route, crossings on it, statuses,   none, built from
                                               optional alternate                  cached feeds

      GET /api/geocode?q=                      Address search near Raleigh         1 hour

      GET /api/health                          Feed health for debugging and the   none
                                               demo


  Every route accepts an optional demo parameter (query string for GET, body field for
  POST). When set to a valid scenario name, the server applies the overrides from section 10
  and marks every returned status simulated: true .

   GET /api/crossings response

     type CrossingsResponse = {
          crossings: Array<{ crossing: Crossing; status: CrossingStatus }>;
       alerts: Alert[];                                     // active flood-related alerts for Wake
     County
          feeds: {
             usgs: { ok: boolean; newestObservation: string | null };
            nws: { ok: boolean };
          };
          fetchedAt: string;                                // ISO timestamp
          demo: string | null;
     };


   GET /api/crossings/[id] response

     type CrossingDetail = {
       crossing: Crossing;
          status: CrossingStatus;
          readings: Array<{ t: string; stageFt: number | null; dischargeCfs: number |
     null }>;
       alerts: Alert[];
     };


   POST /api/route/check




                                                                                                      Page 14 of 33
Wake Drive - Full Build Spec for Claude Code




     // request
     type RouteCheckRequest = {
          start: { lat: number; lng: number };
          end: { lat: number; lng: number };
          demo?: string;
     };


     // response
     type RouteInfo = {
       geometry: { type: "LineString"; coordinates: [number, number][] }; // [lng,
     lat]
          distanceM: number;
          durationS: number;
          crossings: Array<{ crossing: Crossing; status: CrossingStatus; alongRouteM:
     number }>;
          overall: Level;
     };

     type RouteCheckResponse = {
          base: RouteInfo;
          alternate: RouteInfo | null;
          alternateNote: string | null;                 // e.g. "No safe alternate found. Consider
     delaying your trip."
          extraDistanceM: number | null;
          extraDurationS: number | null;
          skippedUnverified: number;                    // crossings that could not be matched to
     a location
          fetchedAt: string;
          demo: string | null;
     };


   GET /api/geocode?q= returns { results: Array<{ label: string; lat: number;
  lng: number }> } , up to 5 results, restricted to the Wake County area.

  Validation and errors. Validate every request with Zod. Return errors in one shape: {
  error: { code: string; message: string } } .


     Status          Code                      When

     400              bad_request              Missing or malformed fields, coordinates not
                                               numbers




                                                                                              Page 15 of 33
Wake Drive - Full Build Spec for Claude Code




     Status          Code                          When

     422              outside_area                 A point is outside the Wake County area

     502              upstream_failed              OpenRouteService fails and no fallback works

     504              upstream_timeout             A feed does not answer within 8 seconds


  A failing USGS or NWS feed is not an HTTP error. The endpoint still returns 200, with
  feeds.<name>.ok = false and affected crossings marked unknown. The app must
  degrade, not crash.

  Implementation rules

        Put each upstream in its own client file ( lib/clients/usgs.ts , nws.ts , ors.ts ) with
        an AbortController timeout of 8 seconds and a single exported function per call.
        Cache with a small in-memory TTL helper ( lib/cache.ts ). On a serverless host this
        cache is per instance, which is fine for this project.
        Read ORS_API_KEY and NWS_USER_AGENT from environment variables, server side only.
        Never use a NEXT_PUBLIC_ prefix for secrets.
        Add a simple per-IP rate limit (for example 30 requests per minute) on
        /api/route/check and /api/geocode to protect the free ORS quota.
        Do not log or store users' start and end coordinates beyond transient request logs.


  9. Frontend
  The frontend is a mobile-first Next.js (App Router) app in TypeScript with Tailwind CSS
  and Leaflet. It is designed for a 360 px wide phone screen first, then scales up to desktop.
  The map is the home screen, and everything else is a panel on top of it.

  Screens


     Route                              Screen             What it shows

      /                                 Map home           Full-screen map of all crossings with status
                                                           markers, a header with the Demo toggle and a
                                                           data-freshness chip, and a bottom sheet with a
                                                           "Check my route" button and a List view toggle




                                                                                                            Page 16 of 33
Wake Drive - Full Build Spec for Claude Code




     Route                              Screen             What it shows

      / (sheet state)                   Route check        Start and end inputs (search, tap map, or use my
                                                           location), then the result card with overall status,
                                                           crossing list, and alternate route comparison

      /crossing/[id]                    Crossing detail    Name, road and creek, status with reasons, current
                                                           water level and flow, a 3-hour trend sparkline, the
                                                           thresholds used and their source, active alerts,
                                                           time of last update

      /saved                            Saved routes       List of saved routes with a one-tap re-check that
                                                           shows each route's current overall status

      /about                            Safety and About   Disclaimer, data sources, credits, AI-use disclosure,
                                                           "Turn around, don't drown" guidance


  Components (all under components/ )

         MapView : Leaflet map, loaded with next/dynamic and ssr: false because Leaflet
        needs window .
         CrossingMarker : a marker built with L.divIcon (do not use Leaflet's default image
        icons, which break under bundlers) showing the status color and icon.
         StatusBadge : icon, color and text label for a level.

         RoutePicker : address search with debounce (300 ms), tap-the-map mode, and a "Use
        my location" button.
         RouteResultCard : overall status first, then crossings in route order, then the alternate
        comparison.
         AlternateCompare : base route against alternate, with extra minutes and miles.
         CrossingRow : name, StatusBadge , the first reason, and a relative "updated 4 min ago"
        time.
         Sparkline : a small inline SVG of recent stage readings, no chart library needed.

         DemoBanner : a persistent bar reading "Simulated data. Not real conditions." whenever
        Demo mode is on.
         FeedStatusChip : shows when a feed is down, for example "Gauge data delayed."

         SafetyFooter : always visible, with the line "Never drive through floodwater. Not
        official guidance."

  State and data fetching



                                                                                                            Page 17 of 33
Wake Drive - Full Build Spec for Claude Code




        Use SWR for GET /api/crossings with refreshInterval of 5 minutes and revalidate
        on focus.
        Route checks are a plain fetch to POST /api/route/check triggered by a button,
        held in component state with loading and error states.
        Saved routes and the Demo toggle live in localStorage through one
         useLocalStorage hook that is safe during server rendering. Wrap every read and write
        in try/catch.

  Map behavior

        Initial view centered on Raleigh (about [35.78, -78.64] ), zoom 11, using
        OpenStreetMap tiles with attribution shown.
        Base route drawn as a solid dark line, alternate as a dashed line in a distinct color. Fit
        the map to the route bounds after a check.
        Tapping a marker opens a popup with name, status label and a Details link.
        Remember Leaflet's [lat, lng] order against GeoJSON's [lng, lat] . Convert only
        through lib/geo.ts .

  Design rules

        Status is always icon plus color plus text. Use lucide-react icons: a check circle for
        green, a triangle alert for yellow, an octagon for red, a question circle for unknown.
        Use high-contrast colors. Starting values: green #1a7f37 , yellow #b58105 with dark
        text, red #cf222e , unknown #57606a . Verify contrast on the final backgrounds.
        Touch targets at least 44 px tall. Visible focus outlines on every interactive element.
        Result updates announce through an aria-live="polite" region.
        Provide the List view as a text alternative to the map. It also keeps the app usable if
        map tiles fail.
        Respect prefers-reduced-motion for any animation.
        Plain language: say "water level" instead of "stage," and "Avoid" instead of "critical."

  PWA basics. Add public/manifest.webmanifest with name, short name, display:
  standalone , theme color and 192 px and 512 px icons, plus apple-touch-icon and the
   theme-color meta tag. This allows Add to Home Screen. A service worker and offline
  mode are out of scope.

  Loading and failure states. Show skeleton placeholders while data loads. If
  /api/crossings fails entirely, show the map with all markers gray and a banner: "Live
  data unavailable. Check conditions before you drive."



                                                                                               Page 18 of 33
Wake Drive - Full Build Spec for Claude Code




  10. Demo mode
  Demo mode simulates a flood so the team can record the video and test the red-route and
  alternate-route flow on any dry day. It changes the inputs to the risk engine, never its
  outputs, so the real logic runs on every demo. It must always be labeled as simulated.

  How it works. When a request carries a valid demo scenario name, the server loads
   data/demo-scenarios.json , replaces the gauge readings and alerts for the listed
  crossings, then runs evaluateCrossing as normal. Each returned status has simulated:
  true .

  Scenario format. Each crossing gets a mode. The server derives numbers from that
  crossing's own thresholds, so a scenario still works if thresholds change.

     {
         "highwater": {
             "label": "Simulated flash flood on Crabtree Creek",
             "crossings": {
               "crabtree-creek-lassiter-mill": "flood",
                  "crabtree-creek-anderson-dr": "flood",
                  "walnut-creek-avent-ferry-rd": "caution"
             },
             "default": "normal"
         },
         "quiet": { "label": "Simulated dry day", "crossings": {}, "default":
     "normal" },
       "feed-down": { "label": "Simulated data outage", "feedsDown": ["usgs",
     "nws"] }
     }



     Mode                 Reading used                   Alert injected

      flood                minorFt plus 0.5 ft, rising   A Flash Flood Warning marked SIMULATED

      caution              actionFt plus 0.2 ft          A Flood Watch marked SIMULATED

      normal               actionFt minus 1 ft, steady   None


  A crossing with no thresholds uses the injected alert alone, so it still turns red or yellow in
  the scenario.

  Scenarios to ship




                                                                                                  Page 19 of 33
Wake Drive - Full Build Spec for Claude Code




         highwater : the main demo. Crabtree Creek crossings red, one Walnut Creek crossing
        yellow, the rest green.
         quiet : all green, to show the contrast with the live view.

         feed-down : both feeds marked failed, so every crossing is unknown. This proves the
        app degrades safely and is worth about ten seconds in the video.

  UI rules

        A Demo toggle in the header, with a scenario picker when on.
        A persistent DemoBanner : "Simulated data. Not real conditions."
        A Simulated tag on every status and result card while on.
        Support ?demo=highwater in the URL so the recording starts in the right state.
        Add a "Try demo route" button that fills in a prepared start and end from data/demo-
        routes.json . Choose a pair that crosses a flood crossing and has a clear alternate.
        Pick it only after the crossings are verified.

  Video honesty. Show the live, real-data view first (with the visible update time), then
  switch to Demo mode and say out loud that the flood is simulated. Judges trust a demo
  that is upfront about what is real.


  11. Repository, setup and commands
  The whole project is one TypeScript repository (a single Next.js app), so both partners
  and Claude Code work in one language and one place. Name it wake-drive .

  Folder structure

     wake-drive/
       CLAUDE.md                               # project instructions for Claude Code (section
     15)
         README.md                             # setup, run, deploy, CREDITS, AI disclosure
         .env.example                          # variable names only, no secrets
         data/
           crossings.json                      # hand-built crossing dataset (section 5)
             demo-scenarios.json               # simulated scenarios (section 10)
             demo-routes.json                  # prepared start/end pairs for the demo
         docs/
           AI_LOG.md                           # running log of AI use (section 13)
         scripts/
             find-gauges.ts                    # lists USGS gauges in Wake County
         public/



                                                                                              Page 20 of 33
Wake Drive - Full Build Spec for Claude Code




             manifest.webmanifest
             icons/                            # 192 and 512 px app icons
         src/
             app/
                  layout.tsx
                  page.tsx                     # map home + route sheet
                  about/page.tsx
                  saved/page.tsx
                  crossing/[id]/page.tsx
                  api/
                      crossings/route.ts
                      crossings/[id]/route.ts
                      route/check/route.ts
                      geocode/route.ts
                      health/route.ts
             components/                       # MapView, CrossingMarker, StatusBadge, ...
             lib/
               types.ts                        # shared types: Crossing, Level, CrossingStatus,
     ...
                  geo.ts                       # [lat,lng] <-> [lng,lat] conversion helpers
                  cache.ts                     # tiny in-memory TTL cache
                  demo.ts                      # applies demo scenarios to inputs
                  routing.ts                   # crossing detection and alternate route logic
                  engine/
                      evaluateCrossing.ts # the risk engine (section 6)
                      evaluateCrossing.test.ts
                  clients/
                      usgs.ts
                      nws.ts
                      ors.ts
                  hooks/
                      useLocalStorage.ts


  Create the project

     npx create-next-app@latest wake-drive --typescript --tailwind --eslint --app
     --src-dir --use-npm
     cd wake-drive
     npm i leaflet react-leaflet @turf/turf swr zod lucide-react
     npm i -D vitest @types/leaflet tsx




                                                                                              Page 21 of 33
Wake Drive - Full Build Spec for Claude Code




  Version note: react-leaflet v5 pairs with React 19, which current Next.js uses. If the
  install reports a peer-dependency conflict, use the version of react-leaflet that
  matches your React major version.

  Environment variables. Create .env.local (git-ignored) from .env.example :

     ORS_API_KEY=                              # free key from openrouteservice.org, created by a
     team member
     NWS_USER_AGENT=WakeDrive (contact: <team email>)


  Never commit .env.local . Never prefix either variable with NEXT_PUBLIC_ .

  npm scripts to add to package.json : "test": "vitest run" and "find-gauges": "tsx
  scripts/find-gauges.ts" . The defaults dev , build , start and lint stay.

   scripts/find-gauges.ts . Fetches the USGS site service URL from section 5 (Wake
  County, stream sites with instantaneous data), skips lines starting with # in the tab-
  separated response, and prints site number, station name, latitude and longitude. The
  partners use the output, plus a map, to choose the gauge for each crossing and fill
  crossings.json .

  Deploy

    1. Push to a GitHub repository (private is fine, but be ready to share code with judges on
       request).
    2. Import the repo into Vercel, add the two environment variables, and deploy.
    3. Open the public URL on a phone and test the full flow, including geolocation, which
       needs HTTPS.
    4. Keep a local npm run dev fallback for recording the video if the deploy misbehaves.

  Code conventions

        TypeScript in strict mode. No any . Shared types live in lib/types.ts , and that file is
        written first so both partners build against the same contract.
        Zod validates every API input. Upstream responses are parsed defensively because
        they can change shape.
        Pure logic (the engine, geometry helpers, demo overrides) takes inputs as arguments
        and has no network calls, so it can be unit tested.
        Commit small and often, with clear messages. Commit history shows the start date
        and each partner's contribution.




                                                                                                Page 22 of 33
Wake Drive - Full Build Spec for Claude Code




  Ownership to avoid merge conflicts. Partner A owns src/components/ and the page files
  under src/app/ (excluding api/ ). Partner B owns src/lib/ , src/app/api/ , data/
  and scripts/ . Changes to lib/types.ts are agreed by both.



  12. Build plan
  The plan runs eight days, from today (Sun Oct 18) to submission on Sun Oct 25, with
  Monday morning held only as a backup. Partner A owns the frontend, Partner B owns data
  and logic, and each day ends with a "done when" check that the whole team can verify.


     Day             Partner A (frontend)        Partner B (data and logic)   Done when

     Sun             Scaffold the Next.js app,   Call USGS, NWS, NWPS         Repo pushed, map
     Oct             agree lib/types.ts with     and OpenRouteService by      renders, all four feeds
     18              B, render the map with      hand once each, run          answered. Both
                     static markers from          find-gauges , start         partners registered on
                      crossings.json              crossings.json with the     the CAC site
                                                 four seed crossings

     Mon              MapView ,                  usgs.ts , nws.ts ,           GET /api/crossings
     Oct              CrossingMarker ,           cache.ts ,                   returns real statuses
     19               StatusBadge , list view    evaluateCrossing with        and the tests pass
                     with placeholder statuses   its unit tests, verify at
                                                 least 5 crossings
                                                 (coordinates and gauge)

     Tue             Connect SWR to              ors.ts (geocode and          A real route (for
     Oct              /api/crossings ,           directions), routing.ts      example Cary to NC
     20              crossing detail page with   crossing detection with      State) returns its
                     sparkline                   Turf, POST                   crossings and statuses
                                                 /api/route/check base
                                                 route

     Wed              RoutePicker ,              Alternate route with avoid   Demo highwater
     Oct              RouteResultCard , draw     polygons, demo.ts and        shows a red crossing
     21              routes on the map           the three scenarios          and a safe alternate on
                                                                              screen




                                                                                                  Page 23 of 33
Wake Drive - Full Build Spec for Claude Code




     Day             Partner A (frontend)         Partner B (data and logic)    Done when

     Thu             Saved routes, About page,    Error handling, rate limit,   Public URL works on
     Oct             DemoBanner , PWA              /api/health , feed-down      two different phones
     22              manifest, accessibility      scenario, tune the avoid
                     pass                         radius and the rapid-rise
                                                  constant from real
                                                  readings, deploy to Vercel

     Fri             User testing with 5 to 10    README with CREDITS,          At least one real quote
     Oct             people, fix the top three    AI_LOG.md complete,           and one measurable
     23              issues                       draft the written answers     result from testers

     Sat             Feature freeze at midday,    Finalize written answers,     Video public, answers
     Oct             bug fixes only. Record the   upload the video as public,   written, deployed app
     24              demo video                   check it plays logged out     stable

     Sun             Final run-through            Submit on the CAC site        Submission confirmed.
     Oct                                          and save the confirmation     Monday morning is
     25                                                                         backup only


  Cut list if behind. Drop in this order: saved routes, sparkline, PWA icons, alternate-route
  polish. Never cut: live data, the risk engine and its tests, Demo mode, and the safety
  disclaimer.

  Daily habit. End each day with a five-minute sync: what works, what is blocked, and the
  next day's first task. Commit before stopping, and add anything AI-generated to
  docs/AI_LOG.md the same day, not later.

  School work. The plan assumes a few hours a day around school. If a day is lost, merge its
  tasks into the next day and cut from the list above. Do not move the Saturday feature
  freeze.



  13. Testing, safety, privacy and AI-use log
  This app tells people about flood danger, so the safety rules below are requirements, not
  polish. The AI-use log is also a competition requirement.


  Testing
  Automated (Vitest, run with npm test )

        The risk engine cases listed in section 6.


                                                                                                    Page 24 of 33
Wake Drive - Full Build Spec for Claude Code




         geo.ts conversions between [lat, lng] and [lng, lat] .
        Crossing detection in routing.ts , using a small fixed route and fixed crossing points,
        covering a crossing on the route, one just outside the match radius, and several
        crossings in order along the route.
        Parsers for USGS and NWS, using saved sample responses in tests/fixtures/ ,
        including a -999999 value and an empty alert list.
        Demo overrides: each mode produces the expected level when passed through the
        real engine.

  Manual checklist (run before the video)

        Full flow on two real phones, on mobile data, not only Wi-Fi.
        A route with no crossings returns green with the correct message.
        A route with a red crossing in Demo mode shows an alternate with extra time and
        distance.
        A case where no alternate exists shows the "consider delaying" message.
        A start point outside Wake County returns the outside_area error and a friendly
        message.
        The feed-down scenario shows every crossing unknown and a visible banner.
        Map tiles blocked: the List view still works.
        Screen reader and keyboard pass on the main flow.

  User testing (Friday). Ask 5 to 10 people (classmates, parents, a driver-ed teacher if
  possible) to check a route they actually drive. Record whether they understood each
  status without help and what confused them. Keep one real quote and one number, such
  as "8 of 10 understood the red label without explanation," for the video and written
  answers.


  Safety rules
    1. Never show green when data is missing, stale, or the alert check failed. Show unknown.
    2. Never describe a crossing as safe. Green means "no flood signals," and the copy must
       say so.
    3. Red copy: "Avoid this crossing. Turn around, don't drown." Never suggest driving
        through water.
    4. Show the data source and last-updated time for every status.




                                                                                           Page 25 of 33
Wake Drive - Full Build Spec for Claude Code




    5. Label team-estimated thresholds as such. Only call a threshold official when it came
        from NWS.
    6. Keep the footer disclaimer on every screen: "Not official guidance. Never drive through
       floodwater. In an emergency call 911."
    7. The About page links to the National Weather Service and the City of Raleigh for
        official information.


  Privacy
        No accounts, no database, no analytics, no ad or tracking scripts.
        Saved routes stay in the user's own browser ( localStorage ) and are never sent to a
        server for storage.
        Location is requested only when the user taps "Use my location," and is used for that
        one request.
        Disclose in the About page that route coordinates are sent to our server and to
        OpenRouteService to compute routes, and that map tiles are requested from
        OpenStreetMap by the user's browser.


  AI-use log and authorship
  The rules allow AI but require full disclosure and significant individual contribution. Keep
   docs/AI_LOG.md current and quote from it in the README and the written answers.

  Log format


    Date           Who             Tool        What AI produced   What we wrote or changed     Checked by

    2026-          Partner         Claude      First draft of     Rewrote the parser for the   Partner A read the diff
    10-19          B               Code        usgs.ts client      -999999 case, added         and ran the tests
                                                                  timeout handling


  The row above is a format example only. Replace it with real entries. Each partner must be
  able to explain every file in the repo without help, because judges may ask for the code
  and Triangle judging panels have included technical reviewers.




                                                                                                                Page 26 of 33
Wake Drive - Full Build Spec for Claude Code




  14. Submission package
  The demo video is the most important part of the submission, and the rules require it to
  be 1 to 3 minutes, public on YouTube or Vimeo, and to state the participants' names, the
  app name, its purpose, its audience, the tools used and a live demonstration. Aim for 2
  minutes 30 seconds.

  Video script


     Time                 On screen                              Say (in your own words)

     0:00 to              Both partners, then the app's map      Your names, the app name, the one-
     0:15                                                        sentence purpose: "Wake Drive checks
                                                                 your route against live creek gauges
                                                                 and weather alerts and reroutes you
                                                                 around flooded crossings." The
                                                                 audience: Wake County drivers,
                                                                 especially new teen drivers

     0:15 to              Map zoomed on Crabtree and Walnut      Why it matters: these creeks flood
     0:35                 Creek crossings                        roads fast, the data exists, but nothing
                                                                 combines it with your route before you
                                                                 leave

     0:35 to              Live app on a phone, real data         Show the status map, tap a crossing to
     1:10                                                        show the water level, source and the
                                                                 visible "updated" time, then check a
                                                                 real route and read the result

     1:10 to              Demo mode on                           Say plainly that this part is simulated.
     1:55                                                        Show the red crossing, the alternate
                                                                 route and the extra minutes

     1:55 to              Code or architecture glimpse, then 5   Tools: TypeScript, Next.js, Leaflet,
     2:15                 seconds of the feed-down scenario      Turf.js, USGS and NWS data,
                                                                 OpenRouteService. Explain that the
                                                                 app shows unknown, never green, when
                                                                 data is missing

     2:15 to              Testing results, then the closing      Your real user-testing quote and
     2:40                 screen                                 number, one sentence disclosing how AI
                                                                 was used, and what comes next




                                                                                                       Page 27 of 33
Wake Drive - Full Build Spec for Claude Code




  Record on a phone or screen recorder in several takes, speak slowly, and test the
  uploaded video while logged out of YouTube.

  Written answers: prompts to answer in your own words. These answers must be yours,
  so use these prompts rather than a pre-written draft.

        Inspiration: What happened, or what did you notice locally, that made you care about
        flooded roads? Use a specific story if you have one.
        Hardest technical problem: Strong candidates are deciding when a status may be
        green without ever misleading a driver, matching a route line to crossing points
        accurately, and combining three live feeds that fail in different ways. Pick the one you
        really struggled with and explain how you solved it.
        What you learned: About APIs, geospatial math, safety-critical design, and teamwork.
        A 2.0 version: Push alerts for saved routes, more counties, roadside sensors, school
        and driver-ed partnerships, and community reports.

  Submission checklist

        Registered on the CAC site with a personal email, both 9-digit ZIP codes and parent or
        guardian contact
        District confirmed using both home and school addresses
        Repository ready to share, with README run steps, CREDITS and the AI-use
        disclosure
        Deployed URL works when logged out and on a phone
        Video is 1 to 3 minutes, public, and plays logged out
        Video states names, app name, purpose, audience, tools and shows a live demo
        Written answers pasted in and proofread
        AI use fully disclosed and docs/AI_LOG.md complete
        Submitted on Sunday, Oct 25, and the confirmation saved


  15. Claude Code instructions
  Set Claude Code up in three steps: export this doc as Markdown to docs/SPEC.md in the
  repo, paste the block below into CLAUDE.md at the repo root, then run the prompts in
  order. Claude Code reads CLAUDE.md automatically at the start of each session, so the
  rules stay in force.

  CLAUDE.md (paste as is)




                                                                                            Page 28 of 33
Wake Drive - Full Build Spec for Claude Code




     # Wake Drive: project instructions


     ## What this is
     Wake Drive is a mobile-first web app for the Congressional App Challenge
     2026. It checks a driver's route against live creek gauges (USGS) and weather
     alerts (NWS) for flood-prone crossings in Wake County, NC, and suggests an
     alternate route when a crossing is red. The full spec is in docs/SPEC.md.
     Read it before starting any task, and follow its section numbers when asked.

     ## Stack
     TypeScript (strict) everywhere. Next.js App Router with route handlers for
     the backend, Tailwind CSS, Leaflet via react-leaflet, Turf.js for geometry,
     SWR for client fetching, Zod for validation, Vitest for tests, lucide-react
     for icons. No database. No user accounts.


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
     3. Never describe a crossing as safe. Green means no flood signals. Keep the
     safety disclaimer on every screen.
     4. Coordinate order: Leaflet uses [lat, lng]. GeoJSON, Turf and
     OpenRouteService use [lng, lat]. Convert only through src/lib/geo.ts.
     5. Secrets (ORS_API_KEY) are server-side only. Never commit .env.local. Never
     use a NEXT_PUBLIC_ prefix for secrets. The browser never calls USGS, NWS or
     OpenRouteService directly.
     6. Demo mode changes the engine's inputs, never its outputs. Everything shown
     in demo mode is marked simulated.
     7. Status is always icon plus color plus text label.
     8. Every upstream call has an 8 second timeout and fails soft: the endpoint
     returns 200 with the feed marked not ok, and affected crossings become
     unknown.


     ## Division of work (competition rules require real student authorship)



                                                                                Page 29 of 33
Wake Drive - Full Build Spec for Claude Code




     The students write the risk engine rules (src/lib/engine), the crossing
     dataset (data/crossings.json) and the demo scenarios. For those files,
     propose changes, review the students' code, and write tests from the spec,
     but do not silently rewrite their logic. Everything else you may draft, and
     the students review it.

     ## Working agreements
     - Work in small steps. After each step run npm test and npm run lint, then
     summarize what changed in plain language so both students can explain it.
     - Ask before adding any new dependency.
     - Add or update an entry in docs/AI_LOG.md at the end of each session: what
     you produced, and what the students must verify.
     - Write unit tests for pure logic first. Use saved fixtures in
     tests/fixtures, never live network calls in tests.
     - Prefer clear, readable code over clever code. Students will present it.
     - If the spec and the code disagree, stop and ask which one is right.


  First prompts, in order

    1. Orient. "Read docs/SPEC.md and CLAUDE.md. Summarize the project in 10 lines and
       list any ambiguities or risks you see. Do not write code yet."
    2. Scaffold and contract. "Following spec section 11, create the folder structure and
        src/lib/types.ts with every shared type from sections 5, 6 and 8. Add the Vitest config
        and the npm scripts. Stop after this and show me the types."
    3. USGS client. "Build src/lib/clients/usgs.ts per spec sections 5 and 8: 8 second timeout,
        defensive parsing, -999999 treated as missing, and a function that computes
        riseFtLastHour. Save a real sample response in tests/fixtures and write tests for the
        parser."
    4. NWS client. "Build src/lib/clients/nws.ts for active alerts at a point, with the required
       User-Agent header from NWS_USER_AGENT. Return null on failure so the engine can
        tell a failed fetch from an empty list. Add fixture-based tests."
    5. Engine tests first. "From spec section 6, write the full Vitest suite for evaluateCrossing
       as failing tests. Do not write the implementation. The students will write it." Then, after
        the students implement it: "Review src/lib/engine/evaluateCrossing.ts against spec
        section 6 and list any case it gets wrong."
    6. Crossings endpoint. "Build GET /api/crossings and GET /api/crossings/[id] per spec
        section 8, using the cache helper, fetching each gauge once, and degrading to unknown
        when a feed fails."




                                                                                            Page 30 of 33
Wake Drive - Full Build Spec for Claude Code




    7. Routing. "Build src/lib/clients/ors.ts and src/lib/routing.ts per spec section 7:
        directions, geocoding, crossing detection with Turf, ordering along the route, and the
        alternate route with avoid polygons. Write tests for crossing detection with a fixed
        route."
    8. Route endpoint. "Build POST /api/route/check per spec section 8, including validation,
       the outside_area error, the rate limit and the alternate-route logic."
    9. Frontend. "Following spec section 9, build the map home screen, the crossing markers
        using divIcon, StatusBadge, the list view and the crossing detail page with a sparkline.
        Mobile first." Then a second prompt for the route picker, result card and alternate
        comparison.
 10. Demo mode. "Implement spec section 10: scenario files, src/lib/demo.ts that modifies
     engine inputs, the header toggle, the banner and ?demo= support."
 11. Polish and safety. "Add the About page, the SafetyFooter, saved routes, the PWA
        manifest and an accessibility pass per spec sections 9 and 13. List every place where
        status could be misread."
 12. Docs. "Draft the README with setup, deploy steps and CREDITS for every library and
        data source, and help me keep docs/AI_LOG.md accurate. Do not write the
        competition answers for us."

  Tips. Start each Claude Code session by telling it which section of the spec you are
  working on. Commit after every prompt that passes tests. If Claude Code proposes
  something that conflicts with a hard rule, say so and ask it to redo the step.


  16. Risks, fallbacks and open items
  The biggest risks are data availability and time, and each has a fallback that keeps the
  project submittable. The open items at the end are things this spec could not verify and
  the team must check in the first two days.


     Risk                                            Fallback

     USGS endpoint changes or goes down              Test the endpoint on day one. Keep saved
                                                     fixtures. If the old endpoint is gone, switch
                                                     to its replacement behind the same
                                                      usgs.ts interface. Show the last good
                                                     reading with its time, and never green once
                                                     it is stale




                                                                                              Page 31 of 33
Wake Drive - Full Build Spec for Claude Code




     Risk                                           Fallback

     No suitable gauge near a crossing              Run that crossing in alert-only mode with
                                                    the reason "No gauge at this crossing." Do
                                                    not show a gauge value

     NWS API returns 403                            Check the User-Agent header. Cache
                                                    responses for 3 minutes to stay polite

     OpenRouteService key delay or free-tier        Create the key today. Cache routes. Fall
     limit                                          back to the OSRM demo server for plain
                                                    routes and accept weaker alternates

     Crossing dataset too small or unverified       Ship 4 to 5 carefully verified crossings
                                                    rather than 10 guessed ones. The demo uses
                                                    verified crossings only

     No real flood during the video week            Demo mode, clearly labeled simulated

     The rapid-rise constant cannot be calibrated   Disable rule 4 (set the threshold to infinity)
     from real readings by Thursday                 and document it as a 2.0 feature

     Users read green as "safe"                     Label text "No flood signals," keep the
                                                    disclaimer on every screen, and test
                                                    comprehension in user testing

     Leaflet breaks in server rendering or          Load the map with next/dynamic and ssr:
     markers do not appear                          false , and use divIcon markers

     Judges cannot run the app                      Public deployed URL, README run steps,
                                                    and a video that shows the full flow

     Falling behind schedule                        Follow the cut list in section 12 and hold the
                                                    Saturday feature freeze

     Deadline confusion                             Submit on Sunday Oct 25. The official
                                                    deadline is noon ET on Monday Oct 26


  Open items to verify

        The USGS iv endpoint returns data for a Wake County gauge today, or find the
        replacement endpoint.
        The real NWPS response format and the NWS gauge IDs (LIDs) for any gauge you use,
        confirmed by calling one by hand.




                                                                                              Page 32 of 33
Wake Drive - Full Build Spec for Claude Code




        Which of the Raleigh flood-warning-sign locations have a usable USGS gauge nearby,
        and which must run alert-only.
        OpenRouteService free-tier limits shown in your account dashboard.
        Each partner's congressional district, using both home and school addresses.
        The binding 2026 deadline. This spec uses noon ET Oct 26 because the national rules
        say so, though NC-13's page says 8:00 PM.
        Whether the submission form asks for a code link or app access, so you can prepare it.
        Any statistic you plan to say in the video, such as rainfall records or the number of
        flood-warning signs. These came from earlier research and local news and should be
        re-checked at the source before you quote them.

  A note on scope. This spec describes one complete, finishable app. If everything above
  works by Friday, resist adding features. A smaller app that works flawlessly in the demo
  will score better than a larger one that almost works.




                                                                                            Page 33 of 33
