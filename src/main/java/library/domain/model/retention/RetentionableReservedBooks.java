package library.domain.model.retention;

import library.domain.model.reservation.reservation.ReservedBook;

import java.util.List;

/**
 * 取置可能な貸出予約
 */
public class RetentionableReservedBooks {
    List<ReservedBook> list;

    public RetentionableReservedBooks(List<ReservedBook> list) {
        this.list = list;
    }

}