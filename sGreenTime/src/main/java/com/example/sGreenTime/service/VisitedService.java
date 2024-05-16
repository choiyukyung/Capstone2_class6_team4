package com.example.sGreenTime.service;

import com.example.sGreenTime.repository.VisitedRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class VisitedService {
    private final VisitedRepository visitedRepository;
}
