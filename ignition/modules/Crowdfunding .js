const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const DEFAULT_DEADLINE = 1893456000; // Example: Jan 1st, 2030
const INITIAL_GOAL = 10_000_000_000n; // Example: 10 Gwei

module.exports = buildModule("CrowdFundingModule", (m) => {
  const deadline = m.getParameter("deadline", DEFAULT_DEADLINE);
  const goal = m.getParameter("goal", INITIAL_GOAL);

  const crowdfunding = m.contract("CrowdFunding", [deadline, goal]);

  return { crowdfunding };
});
