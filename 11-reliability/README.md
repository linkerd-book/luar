# Linkerd Up and Running: Resilience Patterns

This is the documentation - and executable code! - for a demo of resilience
Linkerd. The easiest way to use this file is to execute it with [demosh].

Things in Markdown comments are safe to ignore when reading this later. When
executing this with [demosh], things after the horizontal rule below (which
is just before a commented `@SHOW` directive) will get displayed.

[demosh]: https://github.com/BuoyantIO/demosh

When you use `demosh` to run this file, your cluster will be checked for you.

<!-- set -e >
<!-- @import demosh/demo-tools.sh -->
<!-- @import demosh/check-requirements.sh -->

<!-- @start_livecast -->

---
<!-- @SHOW -->

# Linkerd Up and Running: Resilience Patterns
## Retries and Timeouts

We're going to show various resilience techniques using the Faces demo (from
https://github.com/BuoyantIO/faces-demo):

- _Retries_ automatically repeat requests that fail; and
- _Timeouts_ cut off requests that take too long.

These are very important techniques for resilience, valuable at many points in
the call stack.

Let's start with a quick look at Faces in the web browser. You'll be able to
see that it's in pretty sorry shape, and you'll be able to look at the Linkerd
dashboard to see how much traffic it generates.

<!-- @browser_then_terminal -->

## RETRIES

Let's start by going after the red frowning faces: those are the ones where
the face service itself is failing. We can tell Linkerd to retry those when
they fail, by adding `isRetryable` to ServiceProfile for the `face` service:

```bash
diff -u99 --color k8s/{01-base,02-retries}/face-profile.yaml
```

We'll apply that...

```bash
kubectl apply -f k8s/02-retries/face-profile.yaml
```

...then go take a look at the results in the browser.

<!-- @browser_then_terminal -->

## RETRIES continued

That works great. Let's do the same for the smiley service.

```bash
diff -u99 --color k8s/{01-base,02-retries}/smiley-profile.yaml
kubectl apply -f k8s/02-retries/smiley-profile.yaml
```

And, again, back to the browser to check it out.

<!-- @browser_then_terminal -->

## RETRIES continued

That just leaves the color service, where the same trick works:

```bash
diff -u99 --color k8s/{01-base,02-retries}/color-profile.yaml
kubectl apply -f k8s/02-retries/color-profile.yaml
```

Back to the browser one last time to check it out.

<!-- @browser_then_terminal -->

## RETRIES continued

Finally, let's go back to the browser to take a look at the load on the
services now. Retries actually _increase_ the load on the services, since they
cause more requests: they're not about protecting the service, they're about
**improving the experience of the client**.

<!-- @browser_then_terminal -->

## TIMEOUTS

Things are a lot better already! but... still too slow, which we can see as
those cells that are fading away. Let's add some timeouts, starting from the
bottom of the call graph this time.

Again, timeouts are not about protecting the service: they are about
**providing agency to the client** by giving the client a chance to decide
what to do when things take too long. In fact, like retries, they _increase_
the load on the service.

We'll start by adding a timeout to the color service. This timeout will give
agency to the face service, as the client of the color service: when a call to
the color service takes too long, the face service will show a pink background
for that cell.

```bash
diff -u99 --color k8s/{02-retries,03-timeouts}/color-profile.yaml
```

Let's apply that and then switch back to the browser to see what's up.

```bash
kubectl apply -f k8s/03-timeouts/color-profile.yaml
```

<!-- @browser_then_terminal -->

## TIMEOUTS continued

Let's continue by adding a timout to the smiley service. The face service
will show a smiley-service timeout as a sleeping face.

```bash
diff -u99 --color k8s/{02-retries,03-timeouts}/smiley-profile.yaml
kubectl apply -f k8s/03-timeouts/smiley-profile.yaml
```

<!-- @browser_then_terminal -->

## TIMEOUTS continued

Finally, we'll add a timeout that lets the GUI decide what to do if the face
service itself takes too long.

When the GUI sees a timeout talking to the face service, it will just keep
showing the user the old data for awhile. There are a lot of applications
where this makes an enormous amount of sense: if you can't get updated data,
the most recent data may still be valuable for some time! Eventually, though,
the app should really show the user that something is wrong: in our GUI,
repeated timeouts eventually lead to a faded sleeping-face cell with a pink
background.

For the moment, too, the GUI will show a counter of timed-out attempts, to
make it a little more clear what's going on.

```bash
diff -u99 --color k8s/{02-retries,03-timeouts}/face-profile.yaml
kubectl apply -f k8s/03-timeouts/face-profile.yaml
```

<!-- @browser_then_terminal -->

# SUMMARY

We've used Linkerd to take a very, very broken application and turn it into
something the user might actually have an OK experience with. Fixing the
application is, of course, still necessary!! but making the user experience
better is a good thing.

<!-- @wait -->
<!-- @show_slides -->
