# Domain-Driven Design

Author: Eric Evans.
ISBN: 0-321-12521-5

## Introduction

This book provides a framework for making design decisions and a technical vocabulary for discussing domain design. It is a synthesis of widely accepted best practices along with my own insights and experiences. Software development teams facing complex domains can use this framework to approach domain-driven design systematically.

## Part I: Putting the Domain Model to Work

A model is a simplification. It is an interpretation of reality that abstracts the aspects relevant to solving the problem at hand and ignores extraneous detail.
Every software program relates to some activity or interest of its user. That subject area to which the user applies the program is the domain of the software.
Software domains usually have little to do with computers, though there are exceptions.
To create software that is valuably involved in users' activities, a development team must bring to bear a body of knowledge related to those activities. The breadth of knowledge required can be daunting. A model is a selectively simplified and consciously structured form of knowledge. An appropriate model makes sense of information and focuses it on a problem.
Domain modeling is not a matter of making as "realistic" a model as possible. Even in a domain of tangible real-world things, our model is an artificial creation. Nor is it just the construction of a software mechanism that gives the necessary results. It is more like moviemaking, loosely representing reality to a particular purpose. Even a documentary film does not show unedited real life. Just as a moviemaker selects aspects of experience and presents them in an idiosyncratic way to tell a story or make a point, a domain modeler chooses a particular model for its utility.

#### The Utility of a Model in Domain-Driven Design

In domain-driven design, three basic uses determine the choice of a model.

1. The model and the heart of the design shape each other: It is the intimate link between the model and the implementation that makes the model relevant and ensures that the analysis that went into it applies to the final product, a running program.

2. The model is the backbone of a language used by all team members: Because of the binding of model and implementation, developers can talk about the program in this language. They can communicate with domain experts without translation. And because the language is based on the model, our natural linguistic abilities can be turned to refining the model itself.

3. The model is distilled knowledge: The model is the team's agreed-upon way of structuring domain knowledge and distinguishing the elements of most interest.

#### The Heart of Software

Developers have to steep themselves in the domain to build up knowledge of the business. They must hone their modeling skills and master domain design.

Technical people enjoy quantifiable problems that exercise their technical skills. Domain work is messy and demands a lot of complicated new knowledge that doesn't seem to add to a computer scientist's capabilities.

Instead, the technical talent goes to work on elaborate frame-works, trying to solve domain problems with technology. Learning about and modeling the domain is left to others. Complexity in the heart of software has to be tackled head-on. To do otherwise is to risk irrelevance.

There are systematic ways of thinking that developers can employ to search for insight and produce effective models. There are design techniques that can bring order to a sprawling software application. Cultivation of these skills makes a developer much more valuable, even in an initially unfamiliar domain.

### Chapter One - Crunching Knowledge

#### Ingredients of Effective Modeling

1. Binding the model and the implementation.
2. Cultivating a language based on the model.
3. Developing a knowledge-rich model: The model isn't just a data schema; it is integral to solving a complex problem. It captures knowledge of various kinds.
4. Distilling the model: Important concepts are added to the model as it become more complete, but equally important, concepts are dropped when they don't prove useful or central.
5. Brainstorming and experimenting.

#### Knowledge Crunching

Knowledge crunching is not a solitary activity. A team of developers and domain experts collaborate, typically led by developers. Together they draw in information and crunch it into a useful form.

The interaction between team members changes as all members crunch the model together. The constant refinement of the domain model forces the developers to learn the important principles of the business they are assisting, rather than to produce functions mechanically. The domain experts often refine their own understanding by being forced to distill what they know to essentials, and they come to understand the conceptual rigor that software projects require.

#### Continuous Learning

