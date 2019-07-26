# How to use this repo
This project is a simple example of how to incrementally apply the components of event sourcing into an existing system.
It starts with a basic rails app with a single `account.rb` model.

Checkout each branch and compare it to the previous one to learn about:
- `001_encapsulate_changes` - name the events
- `002_create_event_objects` - create an object for events
- `003_unify_event_handling` - use generic interface for handling events
- `004_persist_events` - create in-memory event-store for saving/retrieving
- `005_projectors` - create subscribers and projectors, separate read & write objects
- `006_commands` - create command objects for handling requests and validations
- `007_reactors` - react to event by doing something else

# A collection of guides on event sourcing for rubyists

### Talks
- An Introduction to CQRS and Event Sourcing Patterns - Mathew McLoughlin https://www.youtube.com/watch?reload=9&v=9a1PqwFrMP0
- Event Sourcing and Stream Processing at Scale - Martin Kleppmann https://www.youtube.com/watch?reload=9&v=avi-TZI9t2I
- Event Sourcing after Launch - Michiel Overeem https://www.youtube.com/watch?reload=9&v=HSJZzFs4cMA
- State or Events? Which Shall I Keep? - Jakub Pilimon, Kenny Bastani https://www.youtube.com/watch?reload=9&v=r7AGQsM7ncA&feature=youtu.be
- An Introduction to Event Sourcing - Alfredo Motta https://skillsmatter.com/skillscasts/11903-an-introduction-to-event-sourcing

### Frameworks
- https://github.com/zilverline/sequent
- https://github.com/envato/event_sourcery
- https://github.com/RailsEventStore/rails_event_store
- https://eventstore.org
- https://serialized.io/docs/basics/overview/
- https://github.com/eventide-project/eventide-event-store

### Example apps
- https://github.com/mpraglowski/cqrses-sample
- https://blog.arkency.com/2015/05/building-an-event-sourced-application-using-rails-event-store/
- https://github.com/RailsEventStore/cqrs-es-sample-with-res
- https://gist.github.com/mottalrd/52a99a0a67275013df5a66281a4a1b11
- https://github.com/methodmissing/aftermath

### Blogs/slides

**Intro**
- https://dev.to/barryosull/event-sourcing-what-it-is-and-why-its-awesome
- http://oierud.net/bliki/EventSourcingInRuby.html
- https://www.sitepoint.com/rails-disco-get-event-sourcing/
- https://codurance.com/2015/07/18/cqrs-and-event-sourcing-for-dummies/
- https://kickstarter.engineering/event-sourcing-made-simple-4a2625113224
- https://martinfowler.com/eaaDev/EventSourcing.html

**More advanced**
- https://blog.kontena.io/event-driven-microservices-with-rabbitmq-and-ruby/
- http://gotocon.com/dl/goto-amsterdam-2013/slides/BobForma_and_LarsVonk_EventSourcingInProductionSystems.pdf
- https://tech.zilverline.com/2017/04/07/elixir_event_sourcing
- https://www.hugopicado.com/2017/05/06/what-event-sourcing-is-not.html
- https://medium.freecodecamp.org/how-to-bridge-stateful-and-event-sourced-systems-70a419842e29
- https://semaphoreci.com/community/tutorials/writing-and-testing-an-event-sourcing-microservice-with-kafka-and-go
- https://lostechies.com/jimmybogard/2012/08/22/busting-some-cqrs-myths/
- https://blog.arkency.com/2015/07/testing-event-sourced-application/
- http://danielwhittaker.me/2014/11/15/aggregate-root-cqrs-event-sourcing/
- https://breadcrumbscollector.tech/implementing-event-sourcing-in-python-part-1-aggregates/
- https://resources.sei.cmu.edu/asset_files/Presentation/2017_017_001_497589.pdf
- https://cqrs.files.wordpress.com/2010/11/cqrs_documents.pdf
- https://railseventstore.org/docs/gdpr/
