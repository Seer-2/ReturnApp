import XCTest
@testable import ReturnApp

final class ProgramPlanTests: XCTestCase {
    func testEightWeekPlanStartsAtBaselineAndEndsAtTarget() {
        let plan=ProgramPlan(startDate:Date(),baselineMinutes:150,targetMinutes:60,durationWeeks:8)
        XCTAssertEqual(plan.allowance(forWeek:1),150)
        XCTAssertEqual(plan.allowance(forWeek:8),60)
    }
    func testAllowanceNeverIncreasesAcrossProgram() {
        let plan=ProgramPlan(startDate:Date(),baselineMinutes:180,targetMinutes:45,durationWeeks:10)
        let allowances=(1...10).map { plan.allowance(forWeek:$0) }
        XCTAssertEqual(allowances,allowances.sorted(by:>))
    }
    func testWeekInputIsClamped() {
        let plan=ProgramPlan(startDate:Date(),baselineMinutes:120,targetMinutes:30,durationWeeks:6)
        XCTAssertEqual(plan.allowance(forWeek:-20),plan.allowance(forWeek:1))
        XCTAssertEqual(plan.allowance(forWeek:200),plan.allowance(forWeek:6))
    }
}
