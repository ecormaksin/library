package library.application.service.member;

import library.application.repository.MemberRepository;
import library.domain.model.member.Members;
import org.springframework.stereotype.Service;

/**
 * 会員参照サービス
 */
@Service
public class MemberQueryService {
    MemberRepository memberRepository;

    MemberQueryService(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

    /**
     * 会員一覧
     */
    public Members findMembers() {
        return memberRepository.findMembers();
    }
}
