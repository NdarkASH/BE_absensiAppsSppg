package com.darknash.AbsensiApps.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PageResponse<T> {

    private T content;
    private int number;
    private int size;
    private long totalPages;
    private boolean hasNext;
    private boolean hasPrevious;
}
