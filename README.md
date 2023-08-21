# Linkerd Up and Running

Welcome to Linkerd Up and Running's code repository! Here you'll find
directories corresponding to chapters in the book, with each directory having
code relevant for that chapter.

For the most part, we use the [Faces Demo] as our tutorial example. It has a
single-page web GUI that presents a grid of cells, each of which _should_ show
a grinning face on a green background (though, in many chapters, you will
absolutely not see that at first).

In most cases, chapters are self-contained, so each chapter will typically
have at least:

- A `README.md` that explains what's up. In most cases, the `README.md` also
  serves as executable code to walk through the chapter. The easiest way to
  follow along is to run the `README.md` with [`demosh`].

- `create-cluster.sh`, a shell script to create a `k3d` cluster and prep it by
  running `setup-cluster.sh`.

- `setup-cluster.sh`, a shell script to set up an empty cluster with
  [Linkerd], [Emissary], the Faces app, and whatever else the chapter needs at
  the start.

   - **WARNING**: `setup-cluster.sh` will install everything in a **demo**
     configuration that is generally **not** acceptable for production use.
     Read and think **carefully** before basing production installations on
     the demo setups!

     In particular, we generally only configure HTTP, not HTTPS. **DON'T** do
     this in production. Additionally, where Emissary is used, we switch it
     from three replicas down to one, which - again - is **not** a good idea
     in production.

A couple of notes here:

- This isn't really a book about ingress controllers, but our demo app
  (deliberately) creates enough traffic, with enough overlapping connections,
  that things run much more smoothly with a proper ingress controller handling
  that job. Since one of our authors is a maintainer of Emissary, we use
  Emissary. If you want to swap in something else, though, go for it!

- Unless stated otherwise, you can run `create-cluster.sh` and
  `setup-cluster.sh` with [demosh], though they're fine with `bash` as well.

## To try this yourself:

- Make sure `$KUBECONFIG` is set correctly.

- If you need to, run `bash create-cluster.sh` to create a new `k3d` cluster to
  use.
   - **Note:** `create-cluster.sh` will delete any existing `k3d` cluster named
     "faces".

- If you already have an empty `k3d` cluster to use, you can run `bash
  setup-cluster.sh` to initialize it. Note that most chapters assume that the
  `k3d` cluster exposes port 80 to the host machine (and you'll see in their
  `create-cluster.sh` scripts how to do this).

- Play around!! Assuming that you're using k3d, the Faces app is reachable at
  http://localhost/faces/.

   - If you're not using `k3d`, you'll need to figure out how to connect to
     the `faces-gui` Service in the `faces` namespace.

- To run the demo as we've given it before, check out [DEMO.md]. The easiest
  way to use that is to run it with [demosh].

[Linkerd]: https://linkerd.io
[Emissary]: https://www.getambassador.io/docs/emissary/
[Faces Demo]: https://github.com/BuoyantIO/faces-demo
[demosh]: https://github.com/BuoyantIO/demosh
