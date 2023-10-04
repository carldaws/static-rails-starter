# Static Rails Starter

This project can be used as a starting point for Rails developers who want to leverage their existing skills to build a static site. It is perfect for personal blogs, portfolio sites and any other site whose visitors don't need dynamic functionality.

## How It Works

In development, this project functions like a normal Rails app. There is a PagesController with all the expected CRUD actions, so you can manage the pages on the site. However, the project also includes a custom rake task (lib/tasks/static_build.rake), run via a handy `bin/build` script which turns the dynamic Rails app into a static site. 

It does this by iterating over all the controllers in the application and rendering the index and show actions to HTML files, assigning the relevant instance variables. 

In the output static pages (in the 'site' directory), none of the CRUD action links are viewable, as the rendering of these is controlled by a `static` local variable, which defaults to false except at build time.

## How To Use

1. Clone the repository
2. `bin/setup`
3. `bin/dev`
4. Create new pages using the app UI, giving them a title, a slug and a (markdown) body
5. `bin/build`
6. Check out the `/site` directory, containing your built static site (if you have python3 installed, try `python3 -m http.server 9000` in the `/site` directory)

## Notes

This project also includes a `bin/backup` script which dumps the database to a SQL file, suitable for checking into a git repo.