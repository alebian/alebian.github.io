# Software Estimation - Demystifying the Black Art

Author: Steve McConnell
ISBN: 978-0-7356-0535-0

## Introduction

Our natural tendency is to think that complex formulas will always produce more accurate results than simple ones. But software projects are influenced by numerous factors that undermine many of the assumptions contained in the complex formulas.

## Chapter 1 - What is an "estimate"?

Estimate: prediction of how long a project will take of how much will it cost.
Target: statement of a desirable business objective.
Commitment: promise to deliver defined functionality at a specific level of quality by a certain date.

Estimation and planning are related topics, but estimation is not planning, and planning is not estimation. Estimation should be treated as an unbiased, analytical process; planning should be treated as a biased, goal-seeking process.

Both estimation and planning are important, but the fundamental differences between the two activities mean that combining the two tends to lead to poor estimates and poor plans.

Most executives don't have the technical background that would allow them to make fine distinctions between estimates, targets, commitments, and plans. So it becomes the technical leader's responsibility to translate the executive's request into more specific technical terms.

A single point estimate is usually a target masquerading as an estimate. Accurate software estimates acknowledge that software projects are assailed by uncertainty from all quarters. Collectively, these various sources of uncertainty mean that project outcomes follow a probability distribution.

You can make a commitment to the optimistic end or the pessimistic end of an estimation range (or anywhere in the middle). The important thing is for you to know where in the range your commitment falls so that you can plan accordingly.

Capers Jones has stated that accuracy with 10% is possible, but only on well controlled projects. Chaotic projects have too much variability to achieve that level of accuracy. A good estimation approach should provide estimates that are within 25% of the actual results 75% of the time (Conte, Dunsmore, and Shen 1986). This evaluation standard is the most common standard used to evaluate estimation accuracy.

It becomes impossible to make a clean analytical assessment of whether the project was estimated accurately, because the software project that was ultimately delivered is not the project that was originally estimated.

In practice, if we deliver a project with about the level of functionality intended, using about the level of resources planned, in about the time frame targeted, then we typically say that the project "met its estimates," despite all the analytical impurities implicit in that statement. Thus, the criteria for a "good" estimate cannot be based on its predictive capability, which is impossible to assess, but on the estimate's ability to support project success.

The primary purpose of software estimation is not to predict a project's outcome; it is to determine whether a project's targets are realistic enough to allow the project to be controlled to meet them.

Executives often don't want an accurate estimate that tells them that the desired functionalities won't fit into the schedule; they want a plan for making as many of the functionalities fit as possible.

If the initial target and initial estimate are within about 20% of each other, the project manager will have enough maneuvering room to control the feature set, schedule, team size, and other parameters to meet the project's business goals.

Estimates don't need to be perfectly accurate as much as they need to be useful. When we have the combination of accurate estimates, good target setting, and good planning and control, we can end up with project results that are close to the "estimates."

> A good estimate is an estimate that provides a clear enough view of the project reality to allow the project leadership to make good decisions about how to control the project to hit its targets.

## Software estimation tips

### Chapter 1

1. Distinguish between estimates, targets and commitments.
2. When you're asked to provide an estimate, determine whether you're supposed to be estimating or figuring out how to hit a target.
3. When you see a single point "estimate," ask whether the number is an estimate or whether it's really a target.
4. When you see a single point estimate, that number's probability is not 100%. Ask what the probability of that number is.

### Chapter 2

5. Don't provide "percentage confident" estimates (especially "90% confident") unless you have a quantitatively derived basis for doing so.
6. Avoid using artificially narrow ranges. Be sure the ranges you use in your estimates don't misrepresent your confidence in your estimates.
7. If you are feeling pressure to make your ranges narrower, verify that the pressure actually is coming from an external source and not from yourself.

### Chapter 3

8. Don't intentionally underestimate. The penalty for underestimation is more severe than the penalty for overestimation. Address concerns about overestimation through planning and control, not by biasing your estimates.
9. Recognize a mismatch between a project's business target and a project's estimate for what it is: valuable risk information that the project might not be successful. Take corrective action early, when it can do some good.
10. Many businesses value predictability more than development time, cost, or flexibility. Be sure you understand what your business values the most.

### Chapter 4

11. Consider the effect of the Cone of Uncertainty on the accuracy of your estimate. Your estimate cannot have more accuracy than is possible at your project's current position within the Cone.
12. Don't assume that the Cone of Uncertainty will narrow itself. You must force the Cone to narrow by removing sources of variability from your project.
13. Account for the Cone of Uncertainty by using predefined uncertainty ranges in your estimates.
14. Account for the Cone of Uncertainty by having one person create the "how much" part of the estimate and a different person create the "how uncertain" part of the estimate.
15. Don't expect better estimation practices alone to provide more accurate estimates for chaotic projects. You can't accurately estimate an out-of-control process.
16. To deal with unstable requirements, consider project control strategies instead of or in addition to estimation strategies.
17. Include time in your estimates for stated requirements, implied requirements, and nonfunctional requirements—that is, all requirements. Nothing can be built for free, and your estimates shouldn't imply that it can.
18. Include all necessary software development activities in your estimates, not just coding and testing.
19. On projects that last longer than a few weeks, include allowances for overhead activities such as vacations, sick days, training days, and company meetings.
20. Don't reduce developer estimates—they're probably too optimistic already.
21. Avoid having "control knobs" on your estimates. While control knobs might give you a feeling of better accuracy, they usually introduce subjectivity and degrade actual accuracy.
22. Don't give off-the-cuff estimates. Even a 15 minute estimate will be more accurate.
23. Match the number of significant digits in your estimate (its precision) to your estimate's accuracy.

### Chapter 5

24. Invest an appropriate amount of effort assessing the size of the software that will be built. The size of the software is the single most significant contributor to project effort and schedule.
25. Don't assume that effort scales up linearly as project size does. Effort scales up exponentially.
26. Use software estimation tools to compute the impact of diseconomies of scale.
27. If you've completed previous projects that are about the same size as the project you're estimating—defined as being within a factor of 3 from largest to smallest—you can safely use a ratio based estimating approach, such as lines of code per staff month, to estimate your new project.
28. Factor the kind of software you develop into your estimate. The kind of software you're developing is the second most significant contributor to project effort and schedule.

### Chapter 6

29. When choosing estimation techniques, consider what you want to estimate, the size of the project, the development stage, the project's development style, and what accuracy you need.

### Chapter 7

30. Count if at all possible. Compute when you can't count. Use judgment alone only as a last resort.
31. Look for something you can count that is a meaningful measure of the scope of work in your environment.
32. Collect historical data that allows you to compute an estimate from a count.
33. Don't discount the power of simple, coarse estimation models such as average effort per defect, average effort per Web page, average effort per story, and average effort per use case.
34. Avoid using expert judgment to tweak an estimate that has been derived through computation. Such "expert judgment" usually degrades the estimate's accuracy.

### Chapter 8

35. Use historical data as the basis for your productivity assumptions. Unlike mutual fund disclosures, your organization's past performance really is your best indicator of future performance.
36. Use historical data to help avoid politically charged estimation discussions arising from assumptions like "My team is below average."
37. In collecting historical data to use for estimation, start small, be sure you understand what you're collecting, and collect the data consistently.
38. Collect a project's historical data as soon as possible after the end of the project.
39. As a project is underway, collect historical data on a periodic basis so that you can build a data-based profile of how your projects run.
40. Use data from your current project (project data) to create highly accurate estimates for the remainder of the project.
41. Use project data or historical data rather than industryaverage data to calibrate your estimates whenever possible. In addition to making your estimates more accurate, historical data will reduce variability in your estimate arising from uncertainty in the productivity assumptions.
42. If you don't currently have historical data, begin collecting it as soon as possible.

### Chapter 9

43. To create the task-level estimates, have the people who will actually do the work create the estimates.
44. Create both Best Case and Worst Case estimates to stimulate thinking about the full range of possible outcomes.
45. Use an estimation checklist to improve your individual estimates. Develop and maintain your own personal checklist to improve your estimation accuracy.
46. Compare actual performance to estimated performance so that you can improve your individual estimates over time.

### Chapter 10

47. Decompose large estimates into small pieces so that you can take advantage of the Law of Large Numbers: the errors on the high side and the errors on the low side cancel each other out to some degree.
48. Use a generic software project work breakdown structure (WBS) to avoid omitting common activities.
49. Use the simple standard deviation formula to compute meaningful aggregate Best Case and Worst Case estimates for estimates containing 10 tasks or fewer.
50. Use the complex standard deviation formula to compute meaningful aggregate Best Case and Worst Case estimates when you have about 10 tasks or more.
51. Don't divide the range from best case to worst case by 6 to obtain standard deviations for individual task estimates. Choose a divisor based on the accuracy of your estimation ranges.
52. Focus on making your Expected Case estimates accurate. If the individual estimates are accurate, aggregation will not create problems. If the individual estimates are not accurate, aggregation will be problematic until you find a way to make them accurate.

### Chapter 11

53. Estimate new projects by comparing them to similar past projects, preferably decomposing the estimate into at least five pieces.
54. Do not address estimation uncertainty by biasing the estimate. Address uncertainty by expressing the estimate in uncertain terms.

### Chapter 12

55. Use fuzzy logic to estimate program size in lines of code.
56. Consider using standard components as a low effort technique to estimate size in a project's early stages.
57. Use story points to obtain an early estimate of an iterative project's effort and schedule that is based on data from the same project.
58. Exercise caution when calculating estimates that use numeric ratings scales. Be sure that the numeric categories in the scale actually work like numbers, not like verbal categories such as small, medium, and large.
59. Use t-shirt sizing to help nontechnical stakeholders rule features in or out while the project is in the wide part of the Cone of Uncertainty.
60. Use proxy-based techniques to estimate test cases, defects, pages of user documentation, and other quantities that are difficult to estimate directly.
61. Count whatever is easiest to count and provides the most accuracy in your environment, collect calibration data on that, and then use that data to create estimates that are well suited to your environment.

### Chapter 13

62. Use group reviews to improve estimation accuracy.
63. Use Wideband Delphi for early in the project estimates, for unfamiliar systems, and when several diverse disciplines will be involved in the project itself.

### Chapter 14

64. Use an estimation software tool to sanity check estimates created by manual methods. Larger projects should rely more heavily on commercial estimation software.
65. Don't treat the output of a software estimation tool as divine revelation. Sanity check estimation tool outputs just as you would other estimates.

### Chapter 15

66. Use multiple estimation techniques, and look for convergence or spread among the results.
67. If different estimation techniques produce different results, try to find the factors that are making the results different. Continue reestimating until the different techniques produce results that converge to within about 5%.
68. If multiple estimates agree and the business target disagrees, trust the estimates.

### Chapter 16

69. Don't debate the output of an estimate. Take the output as a given. Change the output only by changing the inputs and recomputing.
70. Focus on estimating size first. Then compute effort, schedule, cost, and features from the size estimate.
71.  Reestimate.
72. Change from less accurate to more accurate estimation approaches as you work your way through a project.
73. When you are ready to hand out specific development task assignments, switch to bottom up estimation.
74. When you reestimate in response to a missed deadline, base the new estimate on the project's actual progress, not on the project's planned progress.
75. Present your estimates in a way that allows you to tighten up your estimates as you move further into the project.
76. Communicate your plan to reestimate to other project stakeholders in advance.

### Chapter 17

77. Develop a Standardized Estimation Procedure at the organizational level; use it at the project level.
78. Coordinate your Standardized Estimation Procedure with your SDLC.
79. Review your projects' estimates and estimation process so that you can improve the accuracy of your estimates and minimize the effort required to create them.

### Chapter 18

80. Use lines of code to estimate size, but remember both the general limitations of simple measures and the specific hazards of the LOC measure in.
81. Count function points to obtain an accurate early in the project size estimate.
82. Use the Dutch Method of counting function points to attain a low cost ballpark estimate early in the project.
83. Use GUI elements to obtain a low effort ballpark estimate in the wide part of the Cone of Uncertainty.
84. With better estimation methods, the size estimate becomes the foundation of all other estimates. The size of the system you're building is the single largest cost driver. Use multiple size estimation techniques to make your size estimate accurate.

### Chapter 19

85. Use software tools based on the science of estimation to most accurately compute effort estimates from your size estimates.
86. Use industry average effort graphs to obtain rough effort estimates in the wide part of the Cone of Uncertainty. For larger projects, remember that more powerful estimation techniques are easily cost justified.
87. Use the ISBSG method to compute a rough effort estimate. Combine it with other methods, and look for convergence or spread among the different estimates.
88. Not all estimation methods are equal. When looking for convergence or spread among estimates, give more weight to the techniques that tend to produce the most accurate results.

### Chapter 20

89. Use the Basic Schedule Equation to estimate schedule early in medium to large projects.
90. Use the Informal Comparison to Past Projects formula to estimate schedule early in a small to large project.
91. Use Jones's First Order Estimation Practice to produce a lowaccuracy (but very low effort) schedule estimate early in a project.
92. Do not shorten a schedule estimate without increasing the effort estimate.
93. Do not shorten a nominal schedule more than 25%. In other words, keep your estimates out of the Impossible Zone.
94. Reduce costs by lengthening the schedule and conducting the project with a smaller team.
95. For medium sized business systems projects (35,000 to 100,000 lines of code) avoid increasing the team size beyond 7 people.
96. Use schedule estimation to ensure your plans are plausible. Use detailed planning to produce the final schedule.
97. Remove the results of overly generic estimation techniques from your data set before you look for convergence or spread among your estimates.

### Chapter 21

98. When allocating project effort across different activities, consider project size, project type, and the kinds of effort contained in the calibration data used to create your initial rolled up estimate.
99. Consider your project's size, type, and development approach in allocating schedule to different activities.
100. Use industry average data or your historical data to estimate the number of defects your project will produce.
101. Use defect removal rate data to estimate the number of defects that your quality assurance practices will remove from your software before it is released.
102. Use your project's total Risk Exposure (RE) as the starting point for buffer planning. Review the details of your project's specific risks to understand whether you should ultimately plan for a buffer that's larger or smaller than the total RE.
103. Planning and estimation are related, and planning is a much bigger topic than can be addressed in one chapter in a book that focuses on software estimation. Read the literature on planning.

### Chapter 22

104. Document and communicate the assumptions embedded in your estimate.
105. Be sure you understand whether you're presenting uncertainty in an estimate or uncertainty that affects your ability to meet a commitment.
106. Don't present project outcomes to other project stakeholders that are only remotely possible.
107. Consider graphic presentation of your estimate as an alternative to text presentation.
108. Use an estimate presentation style that reinforces the message you want to communicate about your estimate's accuracy.
109. Don't try to express a commitment as a range. A commitment needs to be specific.

### Chapter 23

110. Understand that executives are assertive by nature and by job description, and plan your estimation discussions accordingly.
111. Be aware of external influences on the target. Communicate that you understand the business requirements and their importance.
112. You can negotiate the commitment, but don't negotiate the estimate.
113. Educate nontechnical stakeholders about effective software estimation practices.
114. Treat estimation discussions as problem solving, not negotiation. Recognize that all project stakeholders are on the same side of the table. Everyone wins, or everyone loses.
115. Attack the problem, not the people.
116. Generate as many planning options as you can to support your organization's goals.
117. As you foster an atmosphere of collaborative problem solving, don't make any commitments based on off the cuff estimates.
118. Resolve discussion deadlocks by returning to the question of, "What will be best for our organization?"
