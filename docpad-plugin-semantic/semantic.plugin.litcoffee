
# Docpad Plugin: Semantic Web

## Introduction

This plugin adds support for semantic web (3.0) vocabularies and/or
ontologies to [Docpad][dp]. Due to the highly volatile nature of new
technologies (and global coordination or adaptation of such
technologies), this plugin I can't try to do everything right all at
once. Furthermore, ontologies can be very complex to anyone remotely
non-linguistic educated, I must try and see and learn and experiment as
well. This also means, should I publish this plugin, it will probably
need a lot of work or require your input as the very least. Should you
posses inside knowledge of web ontologies and care to share this with
our community, we more than welcome this.

This is also the main motivation behind the choice for a literate
CoffeeScript document over a regular (moderately) commented code file.
It will allow for better backtracking of past decisions and rationale
so we may decide otherwise in a later stage.

## Convention and notation in this document

I shall use the quoted blocks `>` in Markdown to denote any open issues
or todo's.

## References and background information

As said earlier, the subjects that involve web semantics may quickly
become too complex, or vague, for mere-mortals such as myself to
understand. Part of the idea behind this plugin is that we share and
combine our collective knowledge on these subjects inside a semantic-
plugin. Much information can be found on the web regarding these
subjects but in here, we will reference a few of the sources that may be
helpful in understanding the (top) overview or (low-level) details of
any that relates to our 'basic' web site building activities.

[Exploiting linked data to build web applications](http://scholar.google.nl/scholar_url?hl=en&q=http://www.researchgate.net/publication/224564103_Exploiting_Linked_Data_to_Build_Web_Applications/file/d912f50cb6135c78d3.pdf&sa=X&scisig=AAGBfm2WP1Fp8251lS7qa0xm2jmqqfdSkA&oi=scholarr&ei=hrhzUaL_EoSlPYnrgNgN&ved=0CCoQgAMoADAA)
[Web Of Trust RDF Ontology](http://xmlns.com/wot/0.1/)
[XML namespaces dot com (unofficial)](http://xmlns.com/)

This section will be expanded with additional information as it arises.

## Plugin pattern and outer scope

Docpad has a well-established plugin pattern that is used as a Node.js
module. We use the `module.exports` method to expose our inner workings
to the outside world (read docpad) so we may utilize this functionality
throughout the entire docpad site should we so desire.

``` coffeescript

    module.exports = (BasePlugin) ->

```

Additionally, the file I used as an example has this (a)synchronous
support tool added which I will leave for now.

``` coffeescript

        {TaskGroup} = require('taskgroup')

```

So, we define our plugin as a derived class from the super-type (or base
class) conveniently named `BasePlugin`. Also, we name our plugin
according to docpad conventional standard by the same name as this file
starts `NAME.plugin.coffee` and the `docpad-plugin-NAME` directory. This
is required for discovery of new plugins. The class name may be anything
you desire, except of course `BasePlugin` but that goes without saying.

``` coffeescript

        class SemanticPlugin extends BasePlugin

            name: 'semantic'

```

## Configuration

Here we define the configuration options which we would like the user
to be able and tweak to their likings.

``` coffeescript

            config:

```

One of the first things that you would want to do, when working with
vocabularies and especially if you want to mix them (for the optimal
result double coverage or because they are specialized ontologies). In
order to prevent any collisions we can define and use these so called
[XML namespaces][xmlns] which allow us to prefix the long URI addresses
such as `http://schema.org/CreativeWork` or something along that line to
`s:CreativeWork`.

> I have no clue whatsoever the exact difference is between
`xmlns` inside the `HEAD` element as opposed to `BODY` or any other but
they might be just that it limits the scope and nothing else. Thus
`head` seems the most 'complete' in coverage but might trigger side-
effects I don't know of yet (comparable to scripts in the head or foot
of the document). So we may need to support both, only one or everything
and anything - I just don't know.

``` coffeescript

                namespaces:
                    body:
                    head:

```

Either way, we may just support the most commonly found namespaces for
ontologies that a lot of web sites around the globe are using currently
and will very likely see much increased usage statistics later this
decade. The reason for this assumption is the trend towards increased
relevance of these semantic tags by the major [search engines][seo30]
vendors in this world.

``` coffeescript

                vocabularies: {'xmlns:s'     : 'http://schema.org/'
                             , 'xmlns:gr'    : 'http://purl.org/goodrelations/v1#'
                             , 'xmlns:rdfs'  : 'http://www.w3.org/2000/01/rdf-schema#'
                             , 'xmlns:vcard' : 'http://www.w3.org/2006/vcard/ns#'
                             , 'xmlns:foaf'  : 'http://xmlns.com/foaf/0.1/'
                             , 'xmlns:xsd'   : 'http://www.w3.org/2001/XMLSchema#'
                             , 'xmlns:v'     : 'http://rdf.data-vocabulary.org/#'
                             , 'xmlns:pto'   : 'http://www.productontology.org/id/'
                             , 'xmlns:wn'    : 'http://xmlns.com/wordnet/1.6/'
                         }

```

The above defined hash may be used, inside a **Coffeecup** body tag **as is**.
It may allow for mixing in head/body like structures.

> I do need to look at polyglot support for other languages in Docpad
> but don't have the test environment for this setup and not made up my
> mind either. This is something we can add later anyway.







[seo30]: <http://www.searchenginejournal.com/schema-101-how-to-implement-schema-org-markups-to-improve-seo-results/58210/>
[xmlns]: <http://www.w3schools.com/xml/xml_namespaces.asp>