////////////////////////////////////////////////////////////////////////
// Crystal Server - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////

#include "server/network/protocol/battlepass_config.hpp"

#include <array>

namespace {
	constexpr uint16_t BATTLEPASS_MAX_STEP = 50;
	constexpr uint32_t BATTLEPASS_STEP_POINTS = 100;
	constexpr uint32_t BATTLEPASS_SEASON_DURATION_SECONDS = 30 * 24 * 60 * 60;
	constexpr uint32_t BATTLEPASS_DAILY_DURATION_SECONDS = 24 * 60 * 60;
	constexpr uint32_t BATTLEPASS_REROLL_BASE_PRICE = 100;
	constexpr uint32_t BATTLEPASS_PREMIUM_PRICE = 500000;

	constexpr uint32_t BATTLEPASS_STORAGE_BASE = 920000;
	constexpr uint32_t BATTLEPASS_STORAGE_PREMIUM_OFFSET = 100000;
	constexpr uint32_t BATTLEPASS_STORAGE_REROLL_OFFSET = 200000;
	constexpr uint32_t BATTLEPASS_STORAGE_CLAIM_OFFSET = 300000;

	constexpr battlepass::RewardCatalogEntry BATTLEPASS_DEFAULT_REWARD = { 1, 3031, 1, 1, 3043, 1 };

	// Season reward catalog (50 steps). Adjust values here to match your season 1:1.
	constexpr std::array<battlepass::RewardCatalogEntry, BATTLEPASS_MAX_STEP> BATTLEPASS_REWARD_CATALOG = {{
		{1, 3031, 100, 1, 3043, 1}, {1, 3031, 200, 1, 3043, 1}, {1, 3031, 300, 1, 3043, 1}, {1, 3031, 400, 1, 3043, 1}, {1, 3031, 500, 1, 3043, 1},
		{1, 3031, 600, 1, 3043, 2}, {1, 3031, 700, 1, 3043, 2}, {1, 3031, 800, 1, 3043, 2}, {1, 3031, 900, 1, 3043, 2}, {1, 3031, 1000, 1, 3043, 2},
		{1, 3031, 1100, 1, 3043, 3}, {1, 3031, 1200, 1, 3043, 3}, {1, 3031, 1300, 1, 3043, 3}, {1, 3031, 1400, 1, 3043, 3}, {1, 3031, 1500, 1, 3043, 3},
		{1, 3031, 1600, 1, 3043, 4}, {1, 3031, 1700, 1, 3043, 4}, {1, 3031, 1800, 1, 3043, 4}, {1, 3031, 1900, 1, 3043, 4}, {1, 3031, 2000, 1, 3043, 4},
		{1, 3031, 2100, 1, 3043, 5}, {1, 3031, 2200, 1, 3043, 5}, {1, 3031, 2300, 1, 3043, 5}, {1, 3031, 2400, 1, 3043, 5}, {1, 3031, 2500, 1, 3043, 5},
		{1, 3031, 2600, 1, 3043, 6}, {1, 3031, 2700, 1, 3043, 6}, {1, 3031, 2800, 1, 3043, 6}, {1, 3031, 2900, 1, 3043, 6}, {1, 3031, 3000, 1, 3043, 6},
		{1, 3031, 3100, 1, 3043, 7}, {1, 3031, 3200, 1, 3043, 7}, {1, 3031, 3300, 1, 3043, 7}, {1, 3031, 3400, 1, 3043, 7}, {1, 3031, 3500, 1, 3043, 7},
		{1, 3031, 3600, 1, 3043, 8}, {1, 3031, 3700, 1, 3043, 8}, {1, 3031, 3800, 1, 3043, 8}, {1, 3031, 3900, 1, 3043, 8}, {1, 3031, 4000, 1, 3043, 8},
		{1, 3031, 4100, 1, 3043, 9}, {1, 3031, 4200, 1, 3043, 9}, {1, 3031, 4300, 1, 3043, 9}, {1, 3031, 4400, 1, 3043, 9}, {1, 3031, 4500, 1, 3043, 9},
		{1, 3031, 4600, 1, 3043, 10}, {1, 3031, 4700, 1, 3043, 10}, {1, 3031, 4800, 1, 3043, 10}, {1, 3031, 4900, 1, 3043, 10}, {1, 3031, 5000, 1, 3043, 12},
	}};

	uint32_t getStorageKey(uint32_t offset, uint32_t seasonId, uint32_t index = 0) {
		return BATTLEPASS_STORAGE_BASE + offset + (seasonId * 1000) + index;
	}
}

namespace battlepass {
	uint16_t getMaxStep() {
		return BATTLEPASS_MAX_STEP;
	}

	uint32_t getStepPoints() {
		return BATTLEPASS_STEP_POINTS;
	}

	uint32_t getSeasonDurationSeconds() {
		return BATTLEPASS_SEASON_DURATION_SECONDS;
	}

	uint32_t getDailyDurationSeconds() {
		return BATTLEPASS_DAILY_DURATION_SECONDS;
	}

	uint32_t getRerollBasePrice() {
		return BATTLEPASS_REROLL_BASE_PRICE;
	}

	uint32_t getPremiumPrice() {
		return BATTLEPASS_PREMIUM_PRICE;
	}

	uint32_t getPremiumStorageKey(uint32_t seasonId) {
		return getStorageKey(BATTLEPASS_STORAGE_PREMIUM_OFFSET, seasonId);
	}

	uint32_t getRerollStorageKey(uint32_t seasonId) {
		return getStorageKey(BATTLEPASS_STORAGE_REROLL_OFFSET, seasonId);
	}

	uint32_t getClaimedStorageKey(uint32_t seasonId, uint32_t rewardId) {
		return getStorageKey(BATTLEPASS_STORAGE_CLAIM_OFFSET, seasonId, rewardId);
	}

	uint32_t buildRewardId(uint16_t stepId, bool premiumReward) {
		return static_cast<uint32_t>(stepId) * 10 + (premiumReward ? 2 : 1);
	}

	RewardCatalogEntry getRewardCatalogEntry(uint16_t stepId) {
		if (stepId == 0 || stepId > BATTLEPASS_REWARD_CATALOG.size()) {
			return BATTLEPASS_DEFAULT_REWARD;
		}

		return BATTLEPASS_REWARD_CATALOG[stepId - 1];
	}
}
