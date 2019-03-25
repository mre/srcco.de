.. title: Why Kubernetes?
.. slug: why-kubernetes
.. date: 2019/03/25 11:36:00
.. tags: kubernetes
.. link:
.. description:
.. previewimage: ../galleries/kubernetes-logo.png
.. type: text

.. image:: ../galleries/kubernetes-logo.png
   :class: left

There are many popular posts about "why you might not need Kubernetes".
I'll try to explain why I believe Kubernetes is worth a close look, even if you just want to run some containers.

.. TEASER_END

DISCLAIMER: No surprise: I'm biased. We run 100+ Kubernetes clusters at Zalando and I'm heavily invested in the Kubernetes topic (as you can see from `my github repos <https://github.com/hjacobs>`_).


My colleague Jan Brennenstuhl recently tweeted that "Running your own kubernetes cluster seems to be the DC of 2019"
https://twitter.com/jbspeakr/status/1109446507592327168

Kelsey Hightower recommends to exercise caution when running stateful workloads on Kubernetes
https://twitter.com/kelseyhightower/status/1109714010369200129


OK, let's imagine you want to run a bunch of containers, what are your options?

* AWS ECS
* AWS Elastic Beanstalk
* ``docker run``
* Kubernetes
* Nomad
* (add your favorite option here)

The Kubernetes API is the unique selling point for me.
I can create Open Source tools like kube-ops-view, kube-downscaler, and kube-janitor, knowing that they will work on any standard Kubernetes API, regardless of managed or self-hosted.

There is no incentive for me personally to invest my time in something proprietary like AWS ECS which I don't use personally and which have limited market share.
I think this network effect will prevail and we will see more and more high-level tools (apps, operators, ..) for Kubernetes.
I'm probably not the first to write this, but I often compare the Kubernetes API with the Linux Kernel: the "world" converged towards the Linux Kernel API (when we talk about containers, 99% of the time the Linux Kernel features like cgroups/namespaces are meant),
now we see a similar trend for the Kubernetes API.


Setting up Kubernetes does not have to be complex or expensive: creating a cluster on DigitalOcean takes less than 4 minutes and is reasonably cheap ($30/month for 3 small nodes with 2 GiB and 1 CPU each).
Running Kubernetes on your Raspberry PI also got easier with `K3s <https://k3s.io/>`_.

The Kubernetes API is valuable regardless of the implementation: the virtual kubelet allows you to run workloads without caring about nodes.
Microsoft already `provides this feature (AKS Virtual Nodes) in their Azure cloud <https://www.youtube.com/watch?v=hXUywTkwmtk>`_.

There are now plenty of options to run the Kubernetes API locally for development or testing:

* Minikube
* kind
* k3s



Matthias Endler wrote: "The takeaway is: don't use Kubernetes just because everybody else does. Carefully evaluate your requirements and check which tool fits the bill."

I can certainly agree with that statement, but from my anecdotal experience, people starting with container orchestration often discount the value of the "standard" Kubernetes API (it's just not part of their requirements list)
--- they are surprised when I tell them that the de-facto standard, extensible API is my main argument for Kubernetes.
I got to know companies switching from AWS ECS to EKS exactly for this reason: they had to solve problems specifically for ECS where for Kubernetes they could use existing Open Source tooling created for the Kubernetes API.


I think you should not underestimate Kubernetes' complexity, but you should also not discount the value of the Kubernetes API.


This is the Internet. It's full of opinions. Make your own decision and know the trade-offs.

