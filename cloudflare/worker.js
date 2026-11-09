// Serves the static site; every host other than the main domain gets a 301 to https://ytconcept.cz.
const MAIN_HOST = "ytconcept.cz";

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.hostname !== MAIN_HOST) {
      return Response.redirect(`https://${MAIN_HOST}${url.pathname}${url.search}`, 301);
    }
    return env.ASSETS.fetch(request);
  },
};
