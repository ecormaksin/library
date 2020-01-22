package library.domain.model.bookonloan;

import library.domain.model.member.Member;
import library.domain.model.member.MemberType;
import library.domain.type.date.Date;
import library.domain.type.date.Days;

import java.util.Comparator;
import java.util.List;

/**
 * 会員の全貸出図書
 */
public class MemberAllBookOnLoans {
    Member member;
    List<BookOnLoan> bookOnLoans;

    public MemberAllBookOnLoans(Member member, List<BookOnLoan> bookOnLoans) {
        this.member = member;
        this.bookOnLoans = bookOnLoans;
    }

    public LoanRestrictions todayLoanRestrictions() {
        Date today = Date.now();
        return loanRestrictions(today);
    }

    public LoanRestrictions loanRestrictions(Date date) {
        DelayStatus delayStatus = worstDelayStatus(date);
        MemberType memberType = member.memberType();

        if (memberType == MemberType.大人 && delayStatus == DelayStatus.遅延日数３日未満) {
            return LoanRestrictions.貸出５冊まで;
        }

        if (memberType == MemberType.子供) {
            if (delayStatus == DelayStatus.遅延日数３日未満) {
                return LoanRestrictions.貸出７冊まで;
            }

            if (delayStatus == DelayStatus.遅延日数７日未満) {
                return LoanRestrictions.貸出４冊まで;
            }
        }

        return LoanRestrictions.貸出不可;
    }

    DelayStatus todayWorstDelayStatus() {
        Date today = Date.now();
        return worstDelayStatus(today);
    }

    DelayStatus worstDelayStatus(Date date) {
        DelayPeriod worstDelayPeriod = bookOnLoans.stream()
                .map(loan -> loan.delayPeriod(date))
                .max(Comparator.comparingInt(period -> period.value.value()))
                .orElse(new DelayPeriod(new Days(0)));

        return worstDelayPeriod.delayStatus();
    }
}