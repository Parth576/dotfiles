---
name: eval
description: This sop provides a structured system for evaluating AI agents through five sequential phases - planning, test data generation, implementation/execution, analysis, and documentation. It guides the creation of comprehensive evaluation pipelines with automated test execution and evidence-based reporting.
type: anthropic-skill
version: "1.0"
---

# EvalKit: Conversational Evaluation Framework for AI Agents

## Overview

This sop provides a structured system for evaluating AI agents through five sequential phases: planning, test data generation, implementation/execution, analysis, and documentation. It guides the creation of comprehensive evaluation pipelines with automated test execution and evidence-based reporting.

## Parameters

- **agent_path** (required): Path to the agent to be evaluated. Supports relative paths, absolute paths, and direct input methods.

**Constraints for parameter acquisition:**
- You MUST obtain the agent_path before proceeding with any evaluation work
- You MUST validate that the agent path exists and is accessible
- You MUST support relative paths, absolute paths, and direct input methods

## Important Notes

**Directory Structure:**
All evaluation artifacts must reside in an `eval/` folder positioned as a sibling to the target agent directory, never nested within it. The framework validates Python 3.11+ availability and checks for existing evaluation artifacts.

**Documentation Access:**
Before implementing evaluation code, documentation access is mandatory. Users must either have access to the Strands Evals SDK documentation or clone the source repository. Implementation cannot proceed without confirming access to current API patterns.

**Phase Dependencies:**
Phases follow a logical sequence: planning precedes data generation, which precedes execution, which precedes analysis. Missing prerequisites trigger clarifying questions offering to create required components.

## Steps

### Phase 1: Planning

Design the evaluation plan by analyzing the agent architecture and defining metrics.

**Constraints:**
- You MUST parse requirements and analyze agent architecture
- You MUST produce `eval/eval-plan.md` following a structured template covering:
  - Evaluation requirements
  - Agent analysis
  - Metrics definition
  - Test data strategy
  - Implementation design
- You MUST navigate to the evaluation project directory (containing both agent and eval folders) before operations
- You MUST validate Python 3.11+ availability
- You MUST check for existing evaluation artifacts

### Phase 2: Test Data Generation

Create test cases based on the established evaluation plan.

**Constraints:**
- You MUST create `eval/test-cases.jsonl` in JSONL format
- You MUST prioritize user-specific requests over pre-planned scenarios
- User input takes precedence over planned test scenarios
- You MUST ensure test cases cover the metrics defined in the evaluation plan
- All evaluation files MUST remain within the `eval/` folder

### Phase 3: Implementation & Execution

Implement and execute the evaluation pipeline.

**Constraints:**
- You MUST implement evaluation pipelines using appropriate evaluation SDK patterns (Case objects and Experiment classes)
- You MUST create `requirements.txt` with necessary dependencies
- You MUST establish virtual environments for isolated execution
- You MUST implement `eval/run_evaluation.py` as the main execution entry point
- You MUST execute evaluations and store results in `eval/results/`
- Real agent execution is required - never simulation or mocking
- The minimal viable version MUST be implemented first, avoiding over-engineering
- You MUST confirm access to current SDK documentation and API patterns before implementation
- All evaluation files MUST remain within the `eval/` folder

### Phase 4: Analysis & Reporting

Analyze results and generate evidence-based reports.

**Constraints:**
- You MUST analyze results for success rates, quality scores, and failure patterns
- You MUST generate `eval/eval-report.md` with evidence-based recommendations
- Recommendations MUST be prioritized as Critical, Quality, or Enhancement issues
- You MUST provide actionable insights based on the evaluation data
- All evaluation files MUST remain within the `eval/` folder

### Phase 5: Completion & Documentation

Finalize documentation and provide execution instructions.

**Constraints:**
- You MUST create `eval/README.md` containing execution instructions
- You MUST document the complete evaluation pipeline setup
- You MUST provide clear instructions for re-running evaluations
- You MUST suggest logical next steps after phase completion
- All evaluation files MUST remain within the `eval/` folder

## Examples

### Example Input
```
agent_path: "./my-agent"
```

### Example Output Structure
```
my-agent/          (the agent being evaluated)
eval/              (sibling directory)
  eval-plan.md
  test-cases.jsonl
  run_evaluation.py
  requirements.txt
  results/
    (evaluation output files)
  eval-report.md
  README.md
```

### Example Workflow
```
Phase 1 - Planning:
  Analyzed agent architecture
  Defined 5 evaluation metrics
  Created eval/eval-plan.md

Phase 2 - Data Generation:
  Generated 20 test cases
  Created eval/test-cases.jsonl

Phase 3 - Implementation & Execution:
  Implemented evaluation pipeline
  Executed all test cases
  Results stored in eval/results/

Phase 4 - Analysis:
  Success rate: 85%
  Identified 2 critical issues
  Generated eval/eval-report.md

Phase 5 - Completion:
  Created eval/README.md
  Documentation finalized
```

## Troubleshooting

### Agent Path Issues
If the agent path is invalid or inaccessible:
- You SHOULD verify the path exists and is readable
- You SHOULD suggest common agent directory structures
- You SHOULD check for typos in the path

### Python Version Issues
If Python 3.11+ is not available:
- You SHOULD inform the user of the requirement
- You SHOULD suggest installation methods for the required Python version
- You SHOULD check for alternative Python installations (pyenv, conda, etc.)

### SDK Documentation Access
If documentation is not accessible:
- You SHOULD suggest installing the appropriate documentation tools
- You SHOULD offer to clone the SDK source repository as an alternative
- You MUST NOT proceed with implementation without confirmed documentation access

### Evaluation Failures
If evaluations fail during execution:
- You SHOULD check agent connectivity and availability
- You SHOULD verify test case format and validity
- You SHOULD review the evaluation pipeline for configuration errors
- You SHOULD ensure the virtual environment has all required dependencies

### Phase Dependency Issues
If a phase is requested out of order:
- You SHOULD inform the user of the required prerequisite phases
- You SHOULD offer to create the missing prerequisites
- You SHOULD explain the logical dependency chain between phases
